import '../../core/models/loan_scheme.dart';
import '../dev/mock_op.dart';
import '../repositories/loan_scheme_repository.dart';
import 'mock_database.dart';
import 'mock_gateway.dart';

class MockLoanSchemeRepository implements LoanSchemeRepository {
  MockLoanSchemeRepository(this._db, this._gateway);

  final MockDatabase _db;
  final MockGateway _gateway;

  @override
  Future<List<LoanScheme>> fetchAll() =>
      _gateway.call(MockOp.read, () => _db.loanSchemes());

  @override
  Future<LoanScheme> create(LoanSchemeDraft draft) =>
      _gateway.call(MockOp.write, () => _db.createLoanScheme(draft));

  @override
  Future<LoanScheme> setActive(String id, bool active) =>
      _gateway.call(MockOp.write, () => _db.setLoanSchemeActive(id, active));

  @override
  Future<void> delete(String id) =>
      _gateway.call(MockOp.write, () => _db.deleteLoanScheme(id));
}
