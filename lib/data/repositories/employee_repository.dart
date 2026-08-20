import '../../core/models/employee.dart';

class EmployeeDraft {
  const EmployeeDraft({
    required this.name,
    required this.mobile,
    this.areaId,
    this.status = EmployeeStatus.active,
  });

  final String name;
  final String mobile;
  final String? areaId;
  final EmployeeStatus status;
}

class EmployeePatch {
  const EmployeePatch({this.name, this.mobile, this.areaId, this.status});

  final String? name;
  final String? mobile;
  final String? areaId;
  final EmployeeStatus? status;
}

abstract interface class EmployeeRepository {
  Future<List<Employee>> fetchAll();

  Future<Employee> create(EmployeeDraft draft);

  Future<Employee> update(String id, EmployeePatch patch);

  Future<void> delete(String id);
}
