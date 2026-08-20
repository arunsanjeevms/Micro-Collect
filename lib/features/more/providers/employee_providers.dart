import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/data_revision.dart';
import '../../../core/data/entity_kind.dart';
import '../../../core/models/employee.dart';
import '../../../data/repositories/employee_repository.dart';
import '../../../data/repositories/repository_providers.dart';

part 'employee_providers.g.dart';

@riverpod
Future<List<Employee>> employees(Ref ref) {
  ref.watch(dataRevisionProvider(EntityKind.employee));
  return ref.watch(employeeRepositoryProvider).fetchAll();
}

@riverpod
class CreateEmployeeController extends _$CreateEmployeeController {
  @override
  FutureOr<Employee?> build() => null;

  Future<Employee?> submit(EmployeeDraft draft) async {
    state = const AsyncLoading<Employee?>();
    final result = await AsyncValue.guard(
      () => ref.read(employeeRepositoryProvider).create(draft),
    );
    if (!ref.mounted) return null;
    state = result;
    return result.value;
  }
}

@riverpod
class UpdateEmployeeController extends _$UpdateEmployeeController {
  @override
  FutureOr<Employee?> build() => null;

  Future<Employee?> submit(String id, EmployeePatch patch) async {
    state = const AsyncLoading<Employee?>();
    final result = await AsyncValue.guard(
      () => ref.read(employeeRepositoryProvider).update(id, patch),
    );
    if (!ref.mounted) return null;
    state = result;
    return result.value;
  }
}

@riverpod
class DeleteEmployeeController extends _$DeleteEmployeeController {
  @override
  FutureOr<void> build() {}

  Future<bool> submit(String id) async {
    state = const AsyncLoading<void>();
    final result = await AsyncValue.guard(
      () => ref.read(employeeRepositoryProvider).delete(id),
    );
    if (!ref.mounted) return false;
    state = result;
    return !result.hasError;
  }
}
