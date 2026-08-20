import '../../core/data/entity_kind.dart';
import '../../core/models/role.dart';
import '../repositories/role_repository.dart';
import 'api_client.dart';
import 'dto_mappers.dart';
import 'remote_change_feed.dart';

class RemoteRoleRepository implements RoleRepository {
  RemoteRoleRepository(this._client, this._changeFeed);

  final ApiClient _client;
  final RemoteChangeFeed _changeFeed;

  @override
  Future<List<Role>> fetchAll() async {
    final json = await _client.get('/roles') as List;
    return json.map((e) => roleFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Role> create(String name) async {
    final json = await _client.post('/roles', body: {'name': name});
    final role = roleFromJson(json as Map<String, dynamic>);
    _changeFeed.publish(const DataChange({EntityKind.role}));
    return role;
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
    final role = roleFromJson(json as Map<String, dynamic>);
    _changeFeed.publish(const DataChange({EntityKind.role}));
    return role;
  }

  @override
  Future<void> delete(String id) async {
    await _client.delete('/roles/$id');
    _changeFeed.publish(const DataChange({EntityKind.role}));
  }
}
