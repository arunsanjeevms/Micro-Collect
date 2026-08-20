import 'dart:async';

import '../../core/data/change_feed.dart';
import '../../core/data/entity_kind.dart';
import '../../core/errors/app_exception.dart';
import '../../core/models/area.dart';
import '../../core/models/borrower.dart';
import '../../core/models/employee.dart';
import '../../core/models/installment.dart';
import '../../core/models/loan.dart';
import '../../core/models/loan_scheme.dart';
import '../../core/models/collection_entry.dart';
import '../../core/models/daily_collection.dart';
import '../../core/models/payment.dart';
import '../../core/models/role.dart';
import '../../core/utils/loan_calculator.dart';
import '../../core/utils/payment_allocator.dart';
import '../../core/utils/schedule_builder.dart';
import '../repositories/area_repository.dart';
import '../repositories/borrower_repository.dart';
import '../repositories/collection_repository.dart';
import '../repositories/employee_repository.dart';
import '../repositories/loan_repository.dart';
import '../repositories/loan_scheme_repository.dart';
import 'demo_seed.dart';

/// Internal mock storage for one role's permission grants, keyed by
/// permission id - matches the backend's RolePermission join table.
class _RoleRecord {
  _RoleRecord({required this.id, required this.name, required this.isSystem})
    : grants = {};

  final String id;
  final String name;
  final bool isSystem;
  final Map<String, bool> grants; // permissionId -> granted
}

/// The single in-memory store every mock repository reads and writes
/// through. Entities cross-reference by id (a payment touches a loan, its
/// instalments, its borrower and today's collection entry all at once), so
/// one shared store is what lets a write keep them consistent - splitting
/// this per entity would just move that coordination problem into a second
/// layer instead of removing it.
class MockDatabase implements ChangeFeed {
  MockDatabase() {
    loadDemo();
  }

  final Map<String, Borrower> _borrowers = {};
  final Map<String, Loan> _loans = {};
  final Map<String, CollectionEntry> _collections = {};
  final Map<String, Payment> _payments = {};
  List<DailyCollection> _weeklyCollections = [];

  final Map<String, Area> _areas = {};
  final Map<String, Employee> _employees = {};
  final Map<String, LoanScheme> _loanSchemes = {};
  final Map<String, ({String key, String label, String group})> _permissions =
      {};
  final Map<String, _RoleRecord> _roles = {};

  final _changesController = StreamController<DataChange>.broadcast();

  @override
  Stream<DataChange> get changes => _changesController.stream;

  // ─── Reads ──────────────────────────────────────────────────────

  List<Borrower> borrowers() => List.unmodifiable(_borrowers.values);

  Borrower? borrower(String id) => _borrowers[id];

  List<Loan> loans() => List.unmodifiable(_loans.values);

  Loan? loan(String id) => _loans[id];

  List<Loan> loansForBorrower(String borrowerId) =>
      _loans.values.where((l) => l.borrowerId == borrowerId).toList();

  List<CollectionEntry> collectionsForDate(DateTime date) =>
      _collections.values.where((c) => _isSameDate(c.dueDate, date)).toList();

  List<DailyCollection> weeklyCollections() =>
      List.unmodifiable(_weeklyCollections);

  List<Payment> paymentsForDate(DateTime date) =>
      _payments.values.where((p) => _isSameDate(p.paidAt, date)).toList()
        ..sort(_newestFirst);

  List<Payment> paymentsForLoan(String loanId) =>
      _payments.values.where((p) => p.loanId == loanId).toList()
        ..sort(_newestFirst);

  List<Payment> paymentsForBorrower(String borrowerId, {int limit = 10}) {
    final all =
        _payments.values.where((p) => p.borrowerId == borrowerId).toList()
          ..sort(_newestFirst);
    return all.take(limit).toList();
  }

  /// paidAt alone isn't a safe sort key: two payments recorded moments
  /// apart can land in the same millisecond, and List.sort isn't stable
  /// for ties. Payment ids are assigned sequentially, so they break the
  /// tie in actual recording order.
  int _newestFirst(Payment a, Payment b) {
    final byDate = b.paidAt.compareTo(a.paidAt);
    return byDate != 0 ? byDate : b.id.compareTo(a.id);
  }

  // ─── Writes ─────────────────────────────────────────────────────

  Borrower insertBorrower(BorrowerDraft draft) {
    final id = _nextId('B', _borrowers.keys);
    final borrower = Borrower(
      id: id,
      name: draft.name,
      mobile: draft.mobile,
      aadhaar: draft.aadhaar,
      village: draft.village,
      address: draft.address,
      pinCode: draft.pinCode,
      joinDate: DateTime.now(),
      activeLoans: 0,
      totalOutstanding: 0,
      status: BorrowerStatus.active,
    );
    _borrowers[id] = borrower;
    _emit(const DataChange({EntityKind.borrower}));
    return borrower;
  }

  Loan insertLoan(LoanDraft draft) {
    final borrower = _borrowers[draft.borrowerId];
    if (borrower == null) {
      throw NotFoundException('Borrower', draft.borrowerId);
    }

    final id = _nextId('L', _loans.keys);
    final totalInstallments = LoanCalculator.installmentCount(
      tenureMonths: draft.tenureMonths,
      frequency: draft.frequency,
    );
    final totalRepayable = LoanCalculator.totalRepayable(
      principal: draft.principal,
      annualRate: draft.annualRate,
      tenureMonths: draft.tenureMonths,
    );
    final installmentAmount = LoanCalculator.installmentAmount(
      totalRepayable: totalRepayable,
      numberOfInstallments: totalInstallments,
    );
    final disbursementDate = DateTime.now();

    final loan = Loan(
      id: id,
      borrowerId: draft.borrowerId,
      borrowerName: borrower.name,
      principal: draft.principal,
      annualRate: draft.annualRate,
      tenureMonths: draft.tenureMonths,
      frequency: draft.frequency,
      totalRepayable: totalRepayable,
      totalPaid: 0,
      paidInstallments: 0,
      totalInstallments: totalInstallments,
      disbursementDate: disbursementDate,
      status: LoanStatus.disbursed,
      installments: ScheduleBuilder.build(
        loanId: id,
        disbursementDate: disbursementDate,
        totalInstallments: totalInstallments,
        installmentAmount: installmentAmount,
        frequency: draft.frequency,
      ),
    );
    _loans[id] = loan;
    _recomputeBorrower(draft.borrowerId);
    _emit(const DataChange({EntityKind.loan, EntityKind.borrower}));
    return loan;
  }

  /// The one transaction the rest of this architecture exists for: a
  /// single payment touches the loan's instalment schedule, its totals and
  /// status, the borrower's derived outstanding/status, today's collection
  /// entry, and the payment log - all updated together and published as
  /// one DataChange, so every screen watching any of those stays correct
  /// without needing to know a payment is what changed.
  PaymentReceipt recordPayment(RecordPaymentInput input) {
    if (input.amount <= 0) {
      throw const ValidationException('Amount must be greater than zero');
    }

    final entry = _collections[input.collectionId];
    if (entry == null) {
      throw NotFoundException('Collection entry', input.collectionId);
    }
    final loan = _loans[entry.loanId];
    if (loan == null) {
      throw NotFoundException('Loan', entry.loanId);
    }

    final now = DateTime.now();

    final allocation = PaymentAllocator.allocate(
      installments: loan.installments,
      amount: input.amount,
      asOf: now,
    );

    final newTotalPaid = loan.totalPaid + input.amount;
    final paidInstallments = allocation.updatedInstallments
        .where(
          (i) =>
              i.status == InstallmentStatus.paid ||
              i.status == InstallmentStatus.advance,
        )
        .length;
    final isClosed = newTotalPaid >= loan.totalRepayable;
    final stillOverdue = allocation.updatedInstallments.any(
      (i) => i.status == InstallmentStatus.overdue,
    );

    final updatedLoan = loan.copyWith(
      installments: allocation.updatedInstallments,
      totalPaid: newTotalPaid,
      paidInstallments: paidInstallments,
      status: isClosed
          ? LoanStatus.closed
          : stillOverdue
          ? LoanStatus.overdue
          : LoanStatus.active,
      closedDate: isClosed ? now : loan.closedDate,
    );
    _loans[loan.id] = updatedLoan;

    final paymentId = _nextId('P', _payments.keys);
    final payment = Payment(
      id: paymentId,
      receiptNo: 'RCP-${paymentId.substring(1)}',
      borrowerId: loan.borrowerId,
      borrowerName: loan.borrowerName,
      loanId: loan.id,
      installmentIds: allocation.touchedInstallmentIds,
      amount: input.amount,
      mode: input.mode,
      notes: input.notes,
      paidAt: now,
    );
    _payments[paymentId] = payment;

    final paidTowardsEntry = (entry.amountPaid ?? 0) + input.amount;
    _collections[entry.id] = entry.copyWith(
      amountPaid: paidTowardsEntry,
      paidDate: now,
      paymentMode: input.mode,
      notes: input.notes ?? entry.notes,
      status: paidTowardsEntry >= entry.totalDue
          ? CollectionStatus.collected
          : CollectionStatus.partial,
    );

    _recomputeBorrower(loan.borrowerId);

    _emit(
      const DataChange({
        EntityKind.loan,
        EntityKind.installment,
        EntityKind.borrower,
        EntityKind.collection,
        EntityKind.payment,
        EntityKind.report,
      }),
    );

    final touchedNumbers = allocation.updatedInstallments
        .where((i) => allocation.touchedInstallmentIds.contains(i.id))
        .map((i) => i.number)
        .toList();

    return PaymentReceipt(
      payment: payment,
      touchedInstallmentNumbers: touchedNumbers,
      newLoanOutstanding: updatedLoan.outstanding,
      newBorrowerOutstanding: _borrowers[loan.borrowerId]!.totalOutstanding,
    );
  }

  /// Settles the rest of a loan's schedule in one payment (used by the
  /// Loan Closure screen for a lump-sum payoff outside the normal daily
  /// collection cycle - the loan's outstanding always equals the sum of
  /// its remaining installment amounts, so the allocator clears every
  /// installment exactly with nothing left partial).
  PaymentReceipt closeLoan(
    String loanId, {
    required PaymentMode mode,
    String? notes,
  }) {
    final loan = _loans[loanId];
    if (loan == null) {
      throw NotFoundException('Loan', loanId);
    }
    if (loan.status == LoanStatus.closed) {
      throw const ValidationException('This loan is already closed');
    }

    final now = DateTime.now();
    final amount = loan.outstanding;

    final allocation = PaymentAllocator.allocate(
      installments: loan.installments,
      amount: amount,
      asOf: now,
    );

    final updatedLoan = loan.copyWith(
      installments: allocation.updatedInstallments,
      totalPaid: loan.totalRepayable,
      paidInstallments: loan.totalInstallments,
      status: LoanStatus.closed,
      closedDate: now,
    );
    _loans[loan.id] = updatedLoan;

    final paymentId = _nextId('P', _payments.keys);
    final payment = Payment(
      id: paymentId,
      receiptNo: 'RCP-${paymentId.substring(1)}',
      borrowerId: loan.borrowerId,
      borrowerName: loan.borrowerName,
      loanId: loan.id,
      installmentIds: allocation.touchedInstallmentIds,
      amount: amount,
      mode: mode,
      notes: notes,
      paidAt: now,
    );
    _payments[paymentId] = payment;

    _recomputeBorrower(loan.borrowerId);

    _emit(
      const DataChange({
        EntityKind.loan,
        EntityKind.installment,
        EntityKind.borrower,
        EntityKind.payment,
        EntityKind.report,
      }),
    );

    final touchedNumbers = allocation.updatedInstallments
        .where((i) => allocation.touchedInstallmentIds.contains(i.id))
        .map((i) => i.number)
        .toList();

    return PaymentReceipt(
      payment: payment,
      touchedInstallmentNumbers: touchedNumbers,
      newLoanOutstanding: updatedLoan.outstanding,
      newBorrowerOutstanding: _borrowers[loan.borrowerId]!.totalOutstanding,
    );
  }

  // ─── Areas ──────────────────────────────────────────────────────

  Area _areaWithStats(Area base) {
    final assigned = _borrowers.values.where((b) => b.areaId == base.id);
    return base.copyWith(
      customers: assigned.length,
      activeLoans: assigned.fold<int>(0, (sum, b) => sum + b.activeLoans),
      outstanding: assigned.fold<double>(
        0,
        (sum, b) => sum + b.totalOutstanding,
      ),
    );
  }

  List<Area> areas() =>
      _areas.values.map(_areaWithStats).toList()
        ..sort((a, b) => a.id.compareTo(b.id));

  Area createArea(AreaDraft draft) {
    if (_areas.values.any((a) => a.code == draft.code)) {
      throw const ValidationException('An area with this code already exists');
    }
    final id = _nextId('AREA', _areas.keys);
    final area = Area(
      id: id,
      code: draft.code,
      name: draft.name,
      active: draft.active,
      customers: 0,
      activeLoans: 0,
      outstanding: 0,
    );
    _areas[id] = area;
    _emit(const DataChange({EntityKind.area}));
    return _areaWithStats(area);
  }

  Area updateArea(String id, AreaPatch patch) {
    final existing = _areas[id];
    if (existing == null) throw NotFoundException('Area', id);
    final updated = existing.copyWith(
      code: patch.code ?? existing.code,
      name: patch.name ?? existing.name,
      active: patch.active ?? existing.active,
    );
    _areas[id] = updated;
    _emit(const DataChange({EntityKind.area}));
    return _areaWithStats(updated);
  }

  void deleteArea(String id) {
    if (!_areas.containsKey(id)) throw NotFoundException('Area', id);
    final hasBorrowers = _borrowers.values.any((b) => b.areaId == id);
    final hasEmployees = _employees.values.any((e) => e.areaId == id);
    if (hasBorrowers || hasEmployees) {
      throw const ValidationException(
        'This area still has borrowers or employees assigned - reassign them first',
      );
    }
    _areas.remove(id);
    _emit(const DataChange({EntityKind.area}));
  }

  // ─── Employees ──────────────────────────────────────────────────

  Employee _withAreaName(Employee e) =>
      e.areaId == null ? e : e.copyWith(areaName: _areas[e.areaId]?.name);

  List<Employee> employees() =>
      _employees.values.map(_withAreaName).toList()
        ..sort((a, b) => a.id.compareTo(b.id));

  Employee createEmployee(EmployeeDraft draft) {
    final id = _nextId('EMP', _employees.keys);
    final employee = Employee(
      id: id,
      name: draft.name,
      mobile: draft.mobile,
      areaId: draft.areaId,
      status: draft.status,
      joinDate: DateTime.now(),
    );
    _employees[id] = employee;
    _emit(const DataChange({EntityKind.employee}));
    return _withAreaName(employee);
  }

  Employee updateEmployee(String id, EmployeePatch patch) {
    final existing = _employees[id];
    if (existing == null) throw NotFoundException('Employee', id);
    final updated = existing.copyWith(
      name: patch.name ?? existing.name,
      mobile: patch.mobile ?? existing.mobile,
      areaId: patch.areaId ?? existing.areaId,
      status: patch.status ?? existing.status,
    );
    _employees[id] = updated;
    _emit(const DataChange({EntityKind.employee}));
    return _withAreaName(updated);
  }

  void deleteEmployee(String id) {
    if (!_employees.containsKey(id)) throw NotFoundException('Employee', id);
    _employees.remove(id);
    _emit(const DataChange({EntityKind.employee}));
  }

  // ─── Loan Schemes ───────────────────────────────────────────────

  List<LoanScheme> loanSchemes() =>
      _loanSchemes.values.toList()..sort((a, b) => a.id.compareTo(b.id));

  LoanScheme createLoanScheme(LoanSchemeDraft draft) {
    if (draft.principalMin > draft.principalMax) {
      throw const ValidationException(
        'principalMin must not exceed principalMax',
      );
    }
    if (draft.tenureMin > draft.tenureMax) {
      throw const ValidationException('tenureMin must not exceed tenureMax');
    }
    final id = _nextId('SCH', _loanSchemes.keys);
    final scheme = LoanScheme(
      id: id,
      code: draft.code,
      name: draft.name,
      active: draft.active,
      principalMin: draft.principalMin,
      principalMax: draft.principalMax,
      tenureMin: draft.tenureMin,
      tenureMax: draft.tenureMax,
      tenureUnit: draft.tenureUnit,
      frequency: draft.frequency,
    );
    _loanSchemes[id] = scheme;
    _emit(const DataChange({EntityKind.loanScheme}));
    return scheme;
  }

  LoanScheme setLoanSchemeActive(String id, bool active) {
    final existing = _loanSchemes[id];
    if (existing == null) throw NotFoundException('Loan scheme', id);
    final updated = existing.copyWith(active: active);
    _loanSchemes[id] = updated;
    _emit(const DataChange({EntityKind.loanScheme}));
    return updated;
  }

  void deleteLoanScheme(String id) {
    if (!_loanSchemes.containsKey(id)) {
      throw NotFoundException('Loan scheme', id);
    }
    _loanSchemes.remove(id);
    _emit(const DataChange({EntityKind.loanScheme}));
  }

  // ─── Roles & Permissions ────────────────────────────────────────

  Role _roleWithPermissions(_RoleRecord record) {
    final groups = <String, List<Permission>>{};
    for (final permission in _permissions.entries) {
      groups
          .putIfAbsent(permission.value.group, () => [])
          .add(
            Permission(
              id: permission.key,
              key: permission.value.key,
              label: permission.value.label,
              granted: record.grants[permission.key] ?? false,
            ),
          );
    }
    return Role(
      id: record.id,
      name: record.name,
      isSystem: record.isSystem,
      permissionGroups: groups.entries
          .map((e) => PermissionGroup(group: e.key, permissions: e.value))
          .toList(),
    );
  }

  List<Role> roles() =>
      _roles.values.map(_roleWithPermissions).toList()
        ..sort((a, b) => a.id.compareTo(b.id));

  Role createRole(String name) {
    if (_roles.values.any((r) => r.name == name)) {
      throw const ValidationException('A role with this name already exists');
    }
    final id = _nextId('ROLE', _roles.keys);
    final record = _RoleRecord(id: id, name: name, isSystem: false);
    _roles[id] = record;
    _emit(const DataChange({EntityKind.role}));
    return _roleWithPermissions(record);
  }

  Role setRolePermission(String roleId, String permissionId, bool granted) {
    final record = _roles[roleId];
    if (record == null) throw NotFoundException('Role', roleId);
    if (!_permissions.containsKey(permissionId)) {
      throw NotFoundException('Permission', permissionId);
    }
    record.grants[permissionId] = granted;
    _emit(const DataChange({EntityKind.role}));
    return _roleWithPermissions(record);
  }

  void deleteRole(String id) {
    final record = _roles[id];
    if (record == null) throw NotFoundException('Role', id);
    if (record.isSystem) {
      throw const ValidationException('System roles cannot be deleted');
    }
    _roles.remove(id);
    _emit(const DataChange({EntityKind.role}));
  }

  void loadDemo() {
    _areas
      ..clear()
      ..addEntries(DemoSeed.areas().map((a) => MapEntry(a.id, a)));
    _borrowers
      ..clear()
      ..addEntries(DemoSeed.borrowers().map((b) => MapEntry(b.id, b)));
    _loans
      ..clear()
      ..addEntries(DemoSeed.loans().map((l) => MapEntry(l.id, l)));
    final now = DateTime.now();
    _collections
      ..clear()
      ..addEntries(
        DemoSeed.todayCollections(now).map((c) => MapEntry(c.id, c)),
      );
    _payments.clear();
    _weeklyCollections = DemoSeed.weeklyCollections(now);
    _employees
      ..clear()
      ..addEntries(DemoSeed.employees().map((e) => MapEntry(e.id, e)));
    _loanSchemes
      ..clear()
      ..addEntries(DemoSeed.loanSchemes().map((s) => MapEntry(s.id, s)));
    _permissions
      ..clear()
      ..addAll(DemoSeed.permissions());
    _roles
      ..clear()
      ..addEntries(
        DemoSeed.roles().map((r) {
          final record = _RoleRecord(
            id: r.id,
            name: r.name,
            isSystem: r.isSystem,
          );
          for (final group in r.permissionGroups) {
            for (final p in group.permissions) {
              record.grants[p.id] = p.granted;
            }
          }
          return MapEntry(r.id, record);
        }),
      );
    for (final id in _borrowers.keys.toList()) {
      _recomputeBorrower(id);
    }
    _emit(const DataChange.all());
  }

  void reset() {
    _areas.clear();
    _borrowers.clear();
    _loans.clear();
    _collections.clear();
    _payments.clear();
    _weeklyCollections = [];
    _employees.clear();
    _loanSchemes.clear();
    _permissions.clear();
    _roles.clear();
    _emit(const DataChange.all());
  }

  void dispose() => _changesController.close();

  // ─── Internals ──────────────────────────────────────────────────

  /// The sole writer of Borrower.activeLoans/totalOutstanding/status - both
  /// are derived from that borrower's loans, so every write that can change
  /// a loan's outstanding balance or status calls this instead of the
  /// borrower being trusted to already carry the right numbers.
  void _recomputeBorrower(String borrowerId) {
    final current = _borrowers[borrowerId];
    if (current == null) return;

    final borrowerLoans = loansForBorrower(borrowerId);
    final active = borrowerLoans.where((l) => l.status != LoanStatus.closed);
    final hasOverdue = active.any((l) => l.status == LoanStatus.overdue);

    _borrowers[borrowerId] = current.copyWith(
      activeLoans: active.length,
      totalOutstanding: active.fold<double>(0, (sum, l) => sum + l.outstanding),
      status: active.isEmpty
          ? BorrowerStatus.closed
          : hasOverdue
          ? BorrowerStatus.overdue
          : BorrowerStatus.active,
    );
  }

  void _emit(DataChange change) => _changesController.add(change);

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _nextId(String prefix, Iterable<String> existingIds) {
    var max = 0;
    for (final id in existingIds) {
      if (!id.startsWith(prefix)) continue;
      final n = int.tryParse(id.substring(prefix.length));
      if (n != null && n > max) max = n;
    }
    return '$prefix${(max + 1).toString().padLeft(3, '0')}';
  }
}
