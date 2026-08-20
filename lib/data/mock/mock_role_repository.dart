import '../../core/models/role.dart';
import '../dev/mock_op.dart';
import '../repositories/role_repository.dart';
import 'mock_database.dart';
import 'mock_gateway.dart';

class MockRoleRepository implements RoleRepository {
  MockRoleRepository(this._db, this._gateway);

  final MockDatabase _db;
  final MockGateway _gateway;

  @override
  Future<List<Role>> fetchAll() =>
      _gateway.call(MockOp.read, () => _db.roles());

  @override
  Future<Role> create(String name) =>
      _gateway.call(MockOp.write, () => _db.createRole(name));

  @override
  Future<Role> setPermission(
    String roleId,
    String permissionId,
    bool granted,
  ) => _gateway.call(
    MockOp.write,
    () => _db.setRolePermission(roleId, permissionId, granted),
  );

  @override
  Future<void> delete(String id) =>
      _gateway.call(MockOp.write, () => _db.deleteRole(id));
}
