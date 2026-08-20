import '../../core/models/area.dart';
import '../../core/models/borrower.dart';
import '../../core/models/collection_entry.dart';
import '../../core/models/employee.dart';
import '../../core/models/installment.dart';
import '../../core/models/loan.dart';
import '../../core/models/loan_scheme.dart';
import '../../core/models/payment.dart';
import '../../core/models/role.dart';
import '../repositories/collection_repository.dart';

/// Hand-written JSON mapping for the API's responses. The domain models
/// use freezed for copyWith/equality but were never wired to
/// json_serializable (the mock backend never needed JSON) - adding that
/// codegen just for this would mean every model picks up a second
/// generated part file for one caller. These mirror the field names the
/// backend's serialize.js produces exactly.

double _num(dynamic v) => (v as num).toDouble();
double? _numOrNull(dynamic v) => v == null ? null : (v as num).toDouble();
DateTime _date(dynamic v) => DateTime.parse(v as String);
DateTime? _dateOrNull(dynamic v) =>
    v == null ? null : DateTime.parse(v as String);

Borrower borrowerFromJson(Map<String, dynamic> j) => Borrower(
  id: j['id'] as String,
  name: j['name'] as String,
  mobile: j['mobile'] as String,
  aadhaar: j['aadhaar'] as String,
  village: j['village'] as String,
  address: j['address'] as String,
  pinCode: j['pinCode'] as String,
  joinDate: _date(j['joinDate']),
  activeLoans: j['activeLoans'] as int,
  totalOutstanding: _num(j['totalOutstanding']),
  status: BorrowerStatus.values.byName(j['status'] as String),
);

Installment installmentFromJson(Map<String, dynamic> j) => Installment(
  id: j['id'] as String,
  number: j['number'] as int,
  dueDate: _date(j['dueDate']),
  amount: _num(j['amount']),
  paidAmount: _numOrNull(j['paidAmount']),
  paidDate: _dateOrNull(j['paidDate']),
  status: InstallmentStatus.values.byName(j['status'] as String),
);

Loan loanFromJson(Map<String, dynamic> j) => Loan(
  id: j['id'] as String,
  borrowerId: j['borrowerId'] as String,
  borrowerName: j['borrowerName'] as String,
  principal: _num(j['principal']),
  annualRate: _num(j['annualRate']),
  tenureMonths: j['tenureMonths'] as int,
  frequency: j['frequency'] as String,
  totalRepayable: _num(j['totalRepayable']),
  totalPaid: _num(j['totalPaid']),
  paidInstallments: j['paidInstallments'] as int,
  totalInstallments: j['totalInstallments'] as int,
  disbursementDate: _date(j['disbursementDate']),
  closedDate: _dateOrNull(j['closedDate']),
  status: LoanStatus.values.byName(j['status'] as String),
  installments: (j['installments'] as List)
      .map((e) => installmentFromJson(e as Map<String, dynamic>))
      .toList(),
);

CollectionEntry collectionEntryFromJson(Map<String, dynamic> j) =>
    CollectionEntry(
      id: j['id'] as String,
      borrowerId: j['borrowerId'] as String,
      borrowerName: j['borrowerName'] as String,
      loanId: j['loanId'] as String,
      previousDue: _num(j['previousDue']),
      amountDue: _num(j['amountDue']),
      amountPaid: _numOrNull(j['amountPaid']),
      dueDate: _date(j['dueDate']),
      paidDate: _dateOrNull(j['paidDate']),
      paymentMode: j['paymentMode'] == null
          ? null
          : PaymentMode.values.byName(j['paymentMode'] as String),
      notes: j['notes'] as String?,
      status: CollectionStatus.values.byName(j['status'] as String),
    );

Payment paymentFromJson(Map<String, dynamic> j) => Payment(
  id: j['id'] as String,
  receiptNo: j['receiptNo'] as String,
  borrowerId: j['borrowerId'] as String,
  borrowerName: j['borrowerName'] as String,
  loanId: j['loanId'] as String,
  installmentIds: (j['installmentIds'] as List).cast<String>(),
  amount: _num(j['amount']),
  mode: PaymentMode.values.byName(j['mode'] as String),
  notes: j['notes'] as String?,
  paidAt: _date(j['paidAt']),
);

PaymentReceipt paymentReceiptFromJson(Map<String, dynamic> j) => PaymentReceipt(
  payment: paymentFromJson(j['payment'] as Map<String, dynamic>),
  touchedInstallmentNumbers: (j['touchedInstallmentNumbers'] as List)
      .cast<int>(),
  newLoanOutstanding: _num(j['newLoanOutstanding']),
  newBorrowerOutstanding: _num(j['newBorrowerOutstanding']),
);

CollectionSummary collectionSummaryFromJson(Map<String, dynamic> j) =>
    CollectionSummary(
      totalDue: _num(j['totalDue']),
      totalCollected: _num(j['totalCollected']),
      collectedCount: j['collectedCount'] as int,
      pendingCount: j['pendingCount'] as int,
      overdueCount: j['overdueCount'] as int,
      partialCount: j['partialCount'] as int,
    );

Area areaFromJson(Map<String, dynamic> j) => Area(
  id: j['id'] as String,
  code: j['code'] as String,
  name: j['name'] as String,
  active: j['active'] as bool,
  customers: j['customers'] as int,
  activeLoans: j['activeLoans'] as int,
  outstanding: _num(j['outstanding']),
);

Employee employeeFromJson(Map<String, dynamic> j) => Employee(
  id: j['id'] as String,
  name: j['name'] as String,
  mobile: j['mobile'] as String,
  areaId: j['areaId'] as String?,
  areaName: j['areaName'] as String?,
  status: EmployeeStatus.values.byName(j['status'] as String),
  joinDate: _date(j['joinDate']),
);

LoanScheme loanSchemeFromJson(Map<String, dynamic> j) => LoanScheme(
  id: j['id'] as String,
  code: j['code'] as String,
  name: j['name'] as String,
  active: j['active'] as bool,
  principalMin: _num(j['principalMin']),
  principalMax: _num(j['principalMax']),
  tenureMin: j['tenureMin'] as int,
  tenureMax: j['tenureMax'] as int,
  tenureUnit: j['tenureUnit'] as String,
  frequency: j['frequency'] as String,
);

Permission _permissionFromJson(Map<String, dynamic> j) => Permission(
  id: j['id'] as String,
  key: j['key'] as String,
  label: j['label'] as String,
  granted: j['granted'] as bool,
);

PermissionGroup _permissionGroupFromJson(Map<String, dynamic> j) =>
    PermissionGroup(
      group: j['group'] as String,
      permissions: (j['permissions'] as List)
          .map((e) => _permissionFromJson(e as Map<String, dynamic>))
          .toList(),
    );

Role roleFromJson(Map<String, dynamic> j) => Role(
  id: j['id'] as String,
  name: j['name'] as String,
  isSystem: j['isSystem'] as bool,
  permissionGroups: (j['permissionGroups'] as List)
      .map((e) => _permissionGroupFromJson(e as Map<String, dynamic>))
      .toList(),
);
