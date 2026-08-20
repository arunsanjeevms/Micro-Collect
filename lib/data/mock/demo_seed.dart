import '../../core/models/area.dart';
import '../../core/models/borrower.dart';
import '../../core/models/collection_entry.dart';
import '../../core/models/daily_collection.dart';
import '../../core/models/employee.dart';
import '../../core/models/installment.dart';
import '../../core/models/loan.dart';
import '../../core/models/loan_scheme.dart';
import '../../core/models/role.dart';
import '../../core/utils/loan_calculator.dart';
import '../../core/utils/schedule_builder.dart';

// Real areas matching the villages already seeded below, rather than
// Stitch's unrelated demo area names - kept in exact sync with
// backend/prisma/seed.js's `areas` list.
const _areaIdByVillage = {
  'Kothapalli': 'AREA001',
  'Rampur': 'AREA002',
  'Chintalapudi': 'AREA003',
};

/// Deterministic sample data for the mock backend.
///
/// Every loan's totals and schedule (other than L001, kept hand-authored for
/// its richer paid/partial/pending mix) are derived from LoanCalculator and
/// ScheduleBuilder rather than hand-typed, so they can never drift out of
/// agreement with each other the way the original static figures could.
/// Borrower.activeLoans/totalOutstanding/status are seeded with placeholders
/// - MockDatabase.loadDemo() recomputes all three from the loans below
/// immediately after loading, so what's written here is never read.
class DemoSeed {
  DemoSeed._();

  static List<Borrower> borrowers() => [
    _borrower(
      id: 'B001',
      name: 'Rajesh Kumar',
      mobile: '9876543210',
      aadhaar: '234567891234',
      village: 'Kothapalli',
      address: 'H.No 3-45, Main Road',
      pinCode: '507001',
      joinDate: DateTime(2024, 3, 15),
    ),
    _borrower(
      id: 'B002',
      name: 'Lakshmi Devi',
      mobile: '9988776655',
      aadhaar: '456789012345',
      village: 'Rampur',
      address: 'Ward 4, Near Temple',
      pinCode: '507002',
      joinDate: DateTime(2024, 1, 10),
    ),
    _borrower(
      id: 'B003',
      name: 'Suresh Reddy',
      mobile: '8877665544',
      aadhaar: '567890123456',
      village: 'Chintalapudi',
      address: 'Opp. School, Bus Stand Road',
      pinCode: '507003',
      joinDate: DateTime(2024, 6, 20),
    ),
    _borrower(
      id: 'B004',
      name: 'Padma Kumari',
      mobile: '7766554433',
      aadhaar: '678901234567',
      village: 'Kothapalli',
      address: 'H.No 7-12, Cross Road',
      pinCode: '507001',
      joinDate: DateTime(2023, 11, 5),
    ),
    _borrower(
      id: 'B005',
      name: 'Venkat Rao',
      mobile: '9654321098',
      aadhaar: '789012345678',
      village: 'Rampur',
      address: 'Ward 2, Market Area',
      pinCode: '507002',
      joinDate: DateTime(2024, 8, 1),
    ),
    _borrower(
      id: 'B006',
      name: 'Sarita Bai',
      mobile: '9543210987',
      aadhaar: '890123456789',
      village: 'Chintalapudi',
      address: 'H.No 11-3, Lake Road',
      pinCode: '507003',
      joinDate: DateTime(2024, 4, 12),
    ),
    _borrower(
      id: 'B007',
      name: 'Mahesh Goud',
      mobile: '9432109876',
      aadhaar: '901234567890',
      village: 'Kothapalli',
      address: 'Near Water Tank, Main Rd',
      pinCode: '507001',
      joinDate: DateTime(2024, 2, 28),
    ),
    _borrower(
      id: 'B008',
      name: 'Anitha Sharma',
      mobile: '9321098765',
      aadhaar: '012345678901',
      village: 'Rampur',
      address: 'Ward 6, Post Office Lane',
      pinCode: '507002',
      joinDate: DateTime(2024, 5, 18),
    ),
  ];

  static List<Loan> loans() => [
    // Kept hand-authored: the one loan that demonstrates a partial
    // instalment alongside paid and pending ones.
    Loan(
      id: 'L001',
      borrowerId: 'B001',
      borrowerName: 'Rajesh Kumar',
      principal: 20000,
      annualRate: 24,
      tenureMonths: 10,
      frequency: 'monthly',
      totalRepayable: 24000,
      totalPaid: 14200,
      paidInstallments: 6,
      totalInstallments: 10,
      disbursementDate: DateTime(2024, 3, 15),
      status: LoanStatus.active,
      installments: _rajeshInstallments,
    ),
    _buildLoan(
      id: 'L002',
      borrowerId: 'B002',
      borrowerName: 'Lakshmi Devi',
      principal: 15000,
      annualRate: 22,
      tenureMonths: 6,
      frequency: 'weekly',
      disbursementDate: DateTime(2024, 5, 1),
      paidInstallments: 12,
      status: LoanStatus.overdue,
    ),
    _buildLoan(
      id: 'L003',
      borrowerId: 'B002',
      borrowerName: 'Lakshmi Devi',
      principal: 25000,
      annualRate: 20,
      tenureMonths: 12,
      frequency: 'monthly',
      disbursementDate: DateTime(2024, 7, 10),
      paidInstallments: 3,
      status: LoanStatus.active,
    ),
    _buildLoan(
      id: 'L004',
      borrowerId: 'B003',
      borrowerName: 'Suresh Reddy',
      principal: 10000,
      annualRate: 24,
      tenureMonths: 6,
      frequency: 'daily',
      disbursementDate: DateTime(2024, 6, 20),
      paidInstallments: 90,
      status: LoanStatus.active,
    ),
    _buildLoan(
      id: 'L005',
      borrowerId: 'B004',
      borrowerName: 'Padma Kumari',
      principal: 8000,
      annualRate: 20,
      tenureMonths: 6,
      frequency: 'monthly',
      disbursementDate: DateTime(2023, 11, 5),
      paidInstallments: 6,
      status: LoanStatus.closed,
      closedDate: DateTime(2024, 5, 5),
    ),
    _buildLoan(
      id: 'L006',
      borrowerId: 'B005',
      borrowerName: 'Venkat Rao',
      principal: 30000,
      annualRate: 22,
      tenureMonths: 12,
      frequency: 'monthly',
      disbursementDate: DateTime(2024, 8, 1),
      paidInstallments: 2,
      status: LoanStatus.active,
    ),
    _buildLoan(
      id: 'L007',
      borrowerId: 'B006',
      borrowerName: 'Sarita Bai',
      principal: 10000,
      annualRate: 22,
      tenureMonths: 6,
      frequency: 'monthly',
      disbursementDate: DateTime(2024, 4, 12),
      paidInstallments: 1,
      status: LoanStatus.overdue,
    ),
    _buildLoan(
      id: 'L008',
      borrowerId: 'B007',
      borrowerName: 'Mahesh Goud',
      principal: 18000,
      annualRate: 24,
      tenureMonths: 12,
      frequency: 'monthly',
      disbursementDate: DateTime(2024, 3, 1),
      paidInstallments: 4,
      status: LoanStatus.active,
    ),
    _buildLoan(
      id: 'L009',
      borrowerId: 'B008',
      borrowerName: 'Anitha Sharma',
      principal: 22000,
      annualRate: 20,
      tenureMonths: 12,
      frequency: 'monthly',
      disbursementDate: DateTime(2024, 5, 20),
      paidInstallments: 3,
      status: LoanStatus.active,
    ),
  ];

  // ─── Today's Collections ───────────────────────────────────────
  // Every borrowerId/loanId pair below is cross-checked against loans()
  // above - the original static MockData had three that pointed at another
  // borrower's loan (C005/C006/C007), which was invisible while data was
  // read-only but would misattribute a payment the moment one is recorded.
  static List<CollectionEntry> todayCollections(DateTime now) => [
    CollectionEntry(
      id: 'C001',
      borrowerId: 'B001',
      borrowerName: 'Rajesh Kumar',
      loanId: 'L001',
      amountDue: 2200,
      amountPaid: 2200,
      dueDate: now,
      paidDate: now,
      paymentMode: PaymentMode.cash,
      status: CollectionStatus.collected,
    ),
    CollectionEntry(
      id: 'C002',
      borrowerId: 'B003',
      borrowerName: 'Suresh Reddy',
      loanId: 'L004',
      amountDue: 62,
      amountPaid: 62,
      dueDate: now,
      paidDate: now,
      paymentMode: PaymentMode.upi,
      status: CollectionStatus.collected,
    ),
    CollectionEntry(
      id: 'C003',
      borrowerId: 'B005',
      borrowerName: 'Venkat Rao',
      loanId: 'L006',
      amountDue: 3050,
      dueDate: now,
      status: CollectionStatus.pending,
    ),
    CollectionEntry(
      id: 'C004',
      borrowerId: 'B002',
      borrowerName: 'Lakshmi Devi',
      loanId: 'L002',
      previousDue: 640, // one missed weekly instalment carried over
      amountDue: 640,
      dueDate: now,
      status: CollectionStatus.overdue,
    ),
    CollectionEntry(
      id: 'C005',
      borrowerId: 'B006',
      borrowerName: 'Sarita Bai',
      loanId: 'L007',
      previousDue: 350, // partial arrears from a prior missed instalment
      amountDue: 850,
      amountPaid: 500,
      dueDate: now,
      paidDate: now,
      paymentMode: PaymentMode.cash,
      notes: 'Will pay remaining tomorrow',
      status: CollectionStatus.partial,
    ),
    CollectionEntry(
      id: 'C006',
      borrowerId: 'B007',
      borrowerName: 'Mahesh Goud',
      loanId: 'L008',
      amountDue: 1520,
      dueDate: now,
      status: CollectionStatus.pending,
    ),
    CollectionEntry(
      id: 'C007',
      borrowerId: 'B008',
      borrowerName: 'Anitha Sharma',
      loanId: 'L009',
      amountDue: 2000,
      amountPaid: 2000,
      dueDate: now,
      paidDate: now,
      paymentMode: PaymentMode.bank,
      status: CollectionStatus.collected,
    ),
  ];

  // ─── Weekly Collection Data (for charts) ───────────────────────
  static List<DailyCollection> weeklyCollections(DateTime now) => List.generate(
    7,
    (i) {
      final date = now.subtract(Duration(days: 6 - i));
      const dues = [
        28500.0,
        31200.0,
        24800.0,
        35000.0,
        29600.0,
        32500.0,
        30000.0,
      ];
      const collected = [
        24850.0,
        28400.0,
        22100.0,
        30500.0,
        25200.0,
        31800.0,
        24850.0,
      ];
      return DailyCollection(date: date, collected: collected[i], due: dues[i]);
    },
  );

  static Borrower _borrower({
    required String id,
    required String name,
    required String mobile,
    required String aadhaar,
    required String village,
    required String address,
    required String pinCode,
    required DateTime joinDate,
  }) {
    return Borrower(
      id: id,
      name: name,
      mobile: mobile,
      aadhaar: aadhaar,
      village: village,
      address: address,
      pinCode: pinCode,
      joinDate: joinDate,
      // Recomputed by MockDatabase.loadDemo() from loans() - never read as-is.
      activeLoans: 0,
      totalOutstanding: 0,
      status: BorrowerStatus.active,
      areaId: _areaIdByVillage[village],
    );
  }

  /// Builds a loan whose totalRepayable, instalment count, instalment amount
  /// and schedule are all derived from the same LoanCalculator/
  /// ScheduleBuilder a real create-loan flow would use, then marks the first
  /// [paidInstallments] of the generated schedule paid (and, for an overdue
  /// loan, the next one overdue) so totalPaid can never disagree with the
  /// schedule it was computed from.
  static Loan _buildLoan({
    required String id,
    required String borrowerId,
    required String borrowerName,
    required double principal,
    required double annualRate,
    required int tenureMonths,
    required String frequency,
    required DateTime disbursementDate,
    required int paidInstallments,
    required LoanStatus status,
    DateTime? closedDate,
  }) {
    final totalInstallments = LoanCalculator.installmentCount(
      tenureMonths: tenureMonths,
      frequency: frequency,
    );
    final totalRepayable = LoanCalculator.totalRepayable(
      principal: principal,
      annualRate: annualRate,
      tenureMonths: tenureMonths,
    );
    final installmentAmount = LoanCalculator.installmentAmount(
      totalRepayable: totalRepayable,
      numberOfInstallments: totalInstallments,
    );

    final schedule = ScheduleBuilder.build(
      loanId: id,
      disbursementDate: disbursementDate,
      totalInstallments: totalInstallments,
      installmentAmount: installmentAmount,
      frequency: frequency,
    );

    final installments = <Installment>[
      for (var i = 0; i < schedule.length; i++)
        if (i < paidInstallments)
          schedule[i].copyWith(
            paidAmount: schedule[i].amount,
            paidDate: schedule[i].dueDate,
            status: InstallmentStatus.paid,
          )
        else if (status == LoanStatus.overdue && i == paidInstallments)
          schedule[i].copyWith(status: InstallmentStatus.overdue)
        else
          schedule[i],
    ];

    return Loan(
      id: id,
      borrowerId: borrowerId,
      borrowerName: borrowerName,
      principal: principal,
      annualRate: annualRate,
      tenureMonths: tenureMonths,
      frequency: frequency,
      totalRepayable: totalRepayable,
      totalPaid: installmentAmount * paidInstallments,
      paidInstallments: paidInstallments,
      totalInstallments: totalInstallments,
      disbursementDate: disbursementDate,
      closedDate: closedDate,
      status: status,
      installments: installments,
    );
  }

  static List<Installment> get _rajeshInstallments => [
    Installment(
      id: 'I001',
      number: 1,
      dueDate: DateTime(2024, 4, 15),
      amount: 2200,
      paidAmount: 2200,
      paidDate: DateTime(2024, 4, 15),
      status: InstallmentStatus.paid,
    ),
    Installment(
      id: 'I002',
      number: 2,
      dueDate: DateTime(2024, 5, 15),
      amount: 2200,
      paidAmount: 2200,
      paidDate: DateTime(2024, 5, 14),
      status: InstallmentStatus.paid,
    ),
    Installment(
      id: 'I003',
      number: 3,
      dueDate: DateTime(2024, 6, 15),
      amount: 2200,
      paidAmount: 2200,
      paidDate: DateTime(2024, 6, 15),
      status: InstallmentStatus.paid,
    ),
    Installment(
      id: 'I004',
      number: 4,
      dueDate: DateTime(2024, 7, 15),
      amount: 2200,
      paidAmount: 2200,
      paidDate: DateTime(2024, 7, 16),
      status: InstallmentStatus.paid,
    ),
    Installment(
      id: 'I005',
      number: 5,
      dueDate: DateTime(2024, 8, 15),
      amount: 2200,
      paidAmount: 2200,
      paidDate: DateTime(2024, 8, 15),
      status: InstallmentStatus.paid,
    ),
    Installment(
      id: 'I006',
      number: 6,
      dueDate: DateTime(2024, 9, 15),
      amount: 2200,
      paidAmount: 2200,
      paidDate: DateTime(2024, 9, 14),
      status: InstallmentStatus.paid,
    ),
    Installment(
      id: 'I007',
      number: 7,
      dueDate: DateTime(2024, 10, 15),
      amount: 2200,
      paidAmount: 1000,
      paidDate: DateTime(2024, 10, 18),
      status: InstallmentStatus.partial,
    ),
    Installment(
      id: 'I008',
      number: 8,
      dueDate: DateTime(2024, 11, 15),
      amount: 2200,
      status: InstallmentStatus.pending,
    ),
    Installment(
      id: 'I009',
      number: 9,
      dueDate: DateTime(2024, 12, 15),
      amount: 2200,
      status: InstallmentStatus.pending,
    ),
    Installment(
      id: 'I010',
      number: 10,
      dueDate: DateTime(2025, 1, 15),
      amount: 2200,
      status: InstallmentStatus.pending,
    ),
  ];

  // ─── Areas ──────────────────────────────────────────────────────
  // customers/activeLoans/outstanding are placeholders here -
  // MockDatabase.loadDemo() recomputes them from the borrowers above via
  // Borrower.areaId, the same way it recomputes borrower aggregates.
  static List<Area> areas() => const [
    Area(
      id: 'AREA001',
      code: 'KTP',
      name: 'Kothapalli',
      active: true,
      customers: 0,
      activeLoans: 0,
      outstanding: 0,
    ),
    Area(
      id: 'AREA002',
      code: 'RAM',
      name: 'Rampur',
      active: true,
      customers: 0,
      activeLoans: 0,
      outstanding: 0,
    ),
    Area(
      id: 'AREA003',
      code: 'CHN',
      name: 'Chintalapudi',
      active: true,
      customers: 0,
      activeLoans: 0,
      outstanding: 0,
    ),
  ];

  // ─── Employees ──────────────────────────────────────────────────
  static List<Employee> employees() => [
    Employee(
      id: 'EMP001',
      name: 'Arun Kumar',
      mobile: '9000011111',
      areaId: 'AREA001',
      areaName: 'Kothapalli',
      status: EmployeeStatus.active,
      joinDate: DateTime(2024, 1, 5),
    ),
    Employee(
      id: 'EMP002',
      name: 'Priya Sharma',
      mobile: '9000022222',
      areaId: 'AREA002',
      areaName: 'Rampur',
      status: EmployeeStatus.active,
      joinDate: DateTime(2024, 2, 10),
    ),
    Employee(
      id: 'EMP003',
      name: 'Rajesh Verma',
      mobile: '9000033333',
      areaId: 'AREA003',
      areaName: 'Chintalapudi',
      status: EmployeeStatus.onField,
      joinDate: DateTime(2024, 3, 20),
    ),
    Employee(
      id: 'EMP004',
      name: 'Karthik S',
      mobile: '9000044444',
      status: EmployeeStatus.office,
      joinDate: DateTime(2024, 4, 1),
    ),
  ];

  // ─── Loan Schemes ───────────────────────────────────────────────
  static List<LoanScheme> loanSchemes() => const [
    LoanScheme(
      id: 'SCH001',
      code: 'WML-01',
      name: 'Weekly Micro Loan',
      active: true,
      principalMin: 2000,
      principalMax: 50000,
      tenureMin: 20,
      tenureMax: 50,
      tenureUnit: 'Weeks',
      frequency: 'weekly',
    ),
    LoanScheme(
      id: 'SCH002',
      code: 'MSL-02',
      name: 'Monthly SME Loan',
      active: true,
      principalMin: 50000,
      principalMax: 500000,
      tenureMin: 6,
      tenureMax: 36,
      tenureUnit: 'Months',
      frequency: 'monthly',
    ),
    LoanScheme(
      id: 'SCH003',
      code: 'DVL-03',
      name: 'Daily Vendor Loan',
      active: true,
      principalMin: 1000,
      principalMax: 10000,
      tenureMin: 30,
      tenureMax: 90,
      tenureUnit: 'Days',
      frequency: 'daily',
    ),
  ];

  // ─── Roles & Permissions ────────────────────────────────────────
  // Kept in exact sync with backend/prisma/seed.js's `permissions` and
  // `roleGrants`, including matching PERM.../ROLE... ids, so both
  // backends show identical Roles & Permissions content.
  static Map<String, ({String key, String label, String group})>
  permissions() => const {
    'PERM001': (
      key: 'collect_payments',
      label: 'Can Collect Payments',
      group: 'Core Functions',
    ),
    'PERM002': (
      key: 'sync_offline_data',
      label: 'Can Sync Offline Data',
      group: 'Core Functions',
    ),
    'PERM003': (
      key: 'register_customers',
      label: 'Can Register Customers',
      group: 'Core Functions',
    ),
    'PERM004': (
      key: 'view_reports_personal',
      label: 'Can View Reports (Personal)',
      group: 'Reporting & Analytics',
    ),
    'PERM005': (
      key: 'view_reports_branch',
      label: 'Can View Branch Reports',
      group: 'Reporting & Analytics',
    ),
    'PERM006': (
      key: 'manage_users',
      label: 'Can Manage Users',
      group: 'System Settings',
    ),
  };

  static List<Role> roles() {
    final perms = permissions();

    Permission perm(String id, bool granted) => Permission(
      id: id,
      key: perms[id]!.key,
      label: perms[id]!.label,
      granted: granted,
    );

    Role role(String id, String name, Map<String, bool> grants) {
      final groups = <String, List<Permission>>{};
      for (final entry in grants.entries) {
        final group = perms[entry.key]!.group;
        groups.putIfAbsent(group, () => []).add(perm(entry.key, entry.value));
      }
      return Role(
        id: id,
        name: name,
        isSystem: true,
        permissionGroups: groups.entries
            .map((e) => PermissionGroup(group: e.key, permissions: e.value))
            .toList(),
      );
    }

    return [
      role('ROLE001', 'Admin', {
        'PERM001': true,
        'PERM002': true,
        'PERM003': true,
        'PERM004': true,
        'PERM005': true,
        'PERM006': true,
      }),
      role('ROLE002', 'Manager', {
        'PERM001': true,
        'PERM002': true,
        'PERM003': true,
        'PERM004': true,
        'PERM005': true,
        'PERM006': false,
      }),
      role('ROLE003', 'Field Officer', {
        'PERM001': true,
        'PERM002': true,
        'PERM003': true,
        'PERM004': true,
        'PERM005': false,
        'PERM006': false,
      }),
      role('ROLE004', 'Cashier', {
        'PERM001': true,
        'PERM002': false,
        'PERM003': false,
        'PERM004': true,
        'PERM005': false,
        'PERM006': false,
      }),
    ];
  }
}
