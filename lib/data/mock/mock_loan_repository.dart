import '../../core/models/collection_entry.dart' show PaymentMode;
import '../../core/models/loan.dart';
import '../repositories/collection_repository.dart' show PaymentReceipt;
import '../dev/mock_op.dart';
import '../repositories/loan_repository.dart';
import 'mock_database.dart';
import 'mock_gateway.dart';

class MockLoanRepository implements LoanRepository {
  MockLoanRepository(this._db, this._gateway);

  final MockDatabase _db;
  final MockGateway _gateway;

  @override
  Future<List<Loan>> fetchAll() =>
      _gateway.call(MockOp.read, () => _db.loans());

  @override
  Future<Loan?> findById(String id) =>
      _gateway.call(MockOp.read, () => _db.loan(id));

  @override
  Future<List<Loan>> fetchForBorrower(String borrowerId) =>
      _gateway.call(MockOp.read, () => _db.loansForBorrower(borrowerId));

  @override
  Future<Loan> create(LoanDraft draft) =>
      _gateway.call(MockOp.write, () => _db.insertLoan(draft));

  @override
  Future<PaymentReceipt> closeLoan(
    String loanId, {
    required PaymentMode mode,
    String? notes,
  }) => _gateway.call(
    MockOp.write,
    () => _db.closeLoan(loanId, mode: mode, notes: notes),
  );
}
