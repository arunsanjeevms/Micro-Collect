import '../../core/models/role.dart';
import '../repositories/role_repository.dart';
import 'api_client.dart';
import 'dto_mappers.dart';

class RemoteRoleRepository implements RoleRepository {
  RemoteRoleRepository(this._client);

  final ApiClient _client;

  @override
  Future<List<Role>> fetchAll() async {
    final json = await _client.get('/roles') as List;
    return json.map((e) => roleFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Role> create(String name) async {
    final json = await _client.post('/roles', body: {'name': name});
    return roleFromJson(json as Map<String, dynamic>);
  }

  @override
  Future<Role> setPermission(
    String roleId,
    String permissionId,
    bool granted,
  ) async {
    final json = await _client.patch(
      '/roles/$roleId/permissions/$permissionId',
      body: {'granted': granted},
    );
    return roleFromJson(json as Map<String, dynamic>);
  }

  @override
  Future<void> delete(String id) => _client.delete('/roles/$id');
}
