import '../../core/models/employee.dart';
import '../dev/mock_op.dart';
import '../repositories/employee_repository.dart';
import 'mock_database.dart';
import 'mock_gateway.dart';

class MockEmployeeRepository implements EmployeeRepository {
  MockEmployeeRepository(this._db, this._gateway);

  final MockDatabase _db;
  final MockGateway _gateway;

  @override
  Future<List<Employee>> fetchAll() =>
      _gateway.call(MockOp.read, () => _db.employees());

  @override
  Future<Employee> create(EmployeeDraft draft) =>
      _gateway.call(MockOp.write, () => _db.createEmployee(draft));

  @override
  Future<Employee> update(String id, EmployeePatch patch) =>
      _gateway.call(MockOp.write, () => _db.updateEmployee(id, patch));

  @override
  Future<void> delete(String id) =>
      _gateway.call(MockOp.write, () => _db.deleteEmployee(id));
}
