import 'dart:async';

import '../../core/data/change_feed.dart';
import '../../core/data/entity_kind.dart';
import '../../core/errors/app_exception.dart';
import '../../core/models/borrower.dart';
import '../../core/models/loan.dart';
import '../../core/models/collection_entry.dart';
import '../../core/models/daily_collection.dart';
import '../../core/utils/loan_calculator.dart';
import '../../core/utils/schedule_builder.dart';
import '../repositories/borrower_repository.dart';
import '../repositories/loan_repository.dart';
import 'demo_seed.dart';

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
  List<DailyCollection> _weeklyCollections = [];

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

  List<CollectionEntry> collectionsForDate(DateTime date) => _collections
      .values
      .where((c) => _isSameDate(c.dueDate, date))
      .toList();

  List<DailyCollection> weeklyCollections() =>
      List.unmodifiable(_weeklyCollections);

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

  void loadDemo() {
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
    _weeklyCollections = DemoSeed.weeklyCollections(now);
    for (final id in _borrowers.keys.toList()) {
      _recomputeBorrower(id);
    }
    _emit(const DataChange.all());
  }

  void reset() {
    _borrowers.clear();
    _loans.clear();
    _collections.clear();
    _weeklyCollections = [];
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
