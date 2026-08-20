import '../../core/models/area.dart';
import '../dev/mock_op.dart';
import '../repositories/area_repository.dart';
import 'mock_database.dart';
import 'mock_gateway.dart';

class MockAreaRepository implements AreaRepository {
  MockAreaRepository(this._db, this._gateway);

  final MockDatabase _db;
  final MockGateway _gateway;

  @override
  Future<List<Area>> fetchAll() =>
      _gateway.call(MockOp.read, () => _db.areas());

  @override
  Future<Area> create(AreaDraft draft) =>
      _gateway.call(MockOp.write, () => _db.createArea(draft));

  @override
  Future<Area> update(String id, AreaPatch patch) =>
      _gateway.call(MockOp.write, () => _db.updateArea(id, patch));

  @override
  Future<void> delete(String id) =>
      _gateway.call(MockOp.write, () => _db.deleteArea(id));
}
