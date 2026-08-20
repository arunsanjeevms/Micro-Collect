import '../../core/models/role.dart';

abstract interface class RoleRepository {
  Future<List<Role>> fetchAll();

  Future<Role> create(String name);

  Future<Role> setPermission(String roleId, String permissionId, bool granted);

  Future<void> delete(String id);
}
