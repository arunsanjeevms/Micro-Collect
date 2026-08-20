import '../../core/models/area.dart';
import '../repositories/area_repository.dart';
import 'api_client.dart';
import 'dto_mappers.dart';

class RemoteAreaRepository implements AreaRepository {
  RemoteAreaRepository(this._client);

  final ApiClient _client;

  @override
  Future<List<Area>> fetchAll() async {
    final json = await _client.get('/areas') as List;
    return json.map((e) => areaFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Area> create(AreaDraft draft) async {
    final json = await _client.post(
      '/areas',
      body: {'code': draft.code, 'name': draft.name, 'active': draft.active},
    );
    return areaFromJson(json as Map<String, dynamic>);
  }

  @override
  Future<Area> update(String id, AreaPatch patch) async {
    final json = await _client.patch(
      '/areas/$id',
      body: {
        if (patch.code != null) 'code': patch.code,
        if (patch.name != null) 'name': patch.name,
        if (patch.active != null) 'active': patch.active,
      },
    );
    return areaFromJson(json as Map<String, dynamic>);
  }

  @override
  Future<void> delete(String id) => _client.delete('/areas/$id');
}
