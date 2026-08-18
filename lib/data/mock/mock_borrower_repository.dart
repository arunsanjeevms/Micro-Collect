import '../../core/models/borrower.dart';
import '../dev/mock_op.dart';
import '../repositories/borrower_repository.dart';
import 'mock_database.dart';
import 'mock_gateway.dart';

class MockBorrowerRepository implements BorrowerRepository {
  MockBorrowerRepository(this._db, this._gateway);

  final MockDatabase _db;
  final MockGateway _gateway;

  @override
  Future<List<Borrower>> fetchAll() =>
      _gateway.call(MockOp.read, () => _db.borrowers());

  @override
  Future<Borrower?> findById(String id) =>
      _gateway.call(MockOp.read, () => _db.borrower(id));

  @override
  Future<Borrower> create(BorrowerDraft draft) =>
      _gateway.call(MockOp.write, () => _db.insertBorrower(draft));
}
