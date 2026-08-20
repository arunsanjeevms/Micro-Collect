import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee.freezed.dart';

enum EmployeeStatus { active, onField, office }

/// ─── Employee Model ──────────────────────────────────────────────
@freezed
abstract class Employee with _$Employee {
  const factory Employee({
    required String id,
    required String name,
    required String mobile,
    String? areaId,
    String? areaName,
    required EmployeeStatus status,
    required DateTime joinDate,
  }) = _Employee;
}
