import '../../core/data/entity_kind.dart';
import '../../core/models/area.dart';
import '../repositories/area_repository.dart';
import 'api_client.dart';
import 'dto_mappers.dart';
import 'remote_change_feed.dart';

class RemoteAreaRepository implements AreaRepository {
  RemoteAreaRepository(this._client, this._changeFeed);

  final ApiClient _client;
  final RemoteChangeFeed _changeFeed;

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
    final area = areaFromJson(json as Map<String, dynamic>);
    _changeFeed.publish(const DataChange({EntityKind.area}));
    return area;
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
    final area = areaFromJson(json as Map<String, dynamic>);
    _changeFeed.publish(const DataChange({EntityKind.area}));
    return area;
  }

  @override
  Future<void> delete(String id) async {
    await _client.delete('/areas/$id');
    _changeFeed.publish(const DataChange({EntityKind.area}));
  }
}
