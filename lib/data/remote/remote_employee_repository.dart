import '../../core/data/entity_kind.dart';
import '../../core/models/employee.dart';
import '../repositories/employee_repository.dart';
import 'api_client.dart';
import 'dto_mappers.dart';
import 'remote_change_feed.dart';

class RemoteEmployeeRepository implements EmployeeRepository {
  RemoteEmployeeRepository(this._client, this._changeFeed);

  final ApiClient _client;
  final RemoteChangeFeed _changeFeed;

  @override
  Future<List<Employee>> fetchAll() async {
    final json = await _client.get('/employees') as List;
    return json
        .map((e) => employeeFromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Employee> create(EmployeeDraft draft) async {
    final json = await _client.post(
      '/employees',
      body: {
        'name': draft.name,
        'mobile': draft.mobile,
        'areaId': draft.areaId,
        'status': draft.status.name,
      },
    );
    final employee = employeeFromJson(json as Map<String, dynamic>);
    _changeFeed.publish(const DataChange({EntityKind.employee}));
    return employee;
  }

  @override
  Future<Employee> update(String id, EmployeePatch patch) async {
    final json = await _client.patch(
      '/employees/$id',
      body: {
        if (patch.name != null) 'name': patch.name,
        if (patch.mobile != null) 'mobile': patch.mobile,
        if (patch.areaId != null) 'areaId': patch.areaId,
        if (patch.status != null) 'status': patch.status!.name,
      },
    );
    final employee = employeeFromJson(json as Map<String, dynamic>);
    _changeFeed.publish(const DataChange({EntityKind.employee}));
    return employee;
  }

  @override
  Future<void> delete(String id) async {
    await _client.delete('/employees/$id');
    _changeFeed.publish(const DataChange({EntityKind.employee}));
  }
}
