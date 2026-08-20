import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/data_revision.dart';
import '../../../core/data/entity_kind.dart';
import '../../../core/models/role.dart';
import '../../../data/repositories/repository_providers.dart';

part 'role_providers.g.dart';

@riverpod
Future<List<Role>> roles(Ref ref) {
  ref.watch(dataRevisionProvider(EntityKind.role));
  return ref.watch(roleRepositoryProvider).fetchAll();
}

@riverpod
class CreateRoleController extends _$CreateRoleController {
  @override
  FutureOr<Role?> build() => null;

  Future<Role?> submit(String name) async {
    state = const AsyncLoading<Role?>();
    final result = await AsyncValue.guard(
      () => ref.read(roleRepositoryProvider).create(name),
    );
    if (!ref.mounted) return null;
    state = result;
    return result.value;
  }
}

@riverpod
class SetRolePermissionController extends _$SetRolePermissionController {
  @override
  FutureOr<Role?> build() => null;

  Future<Role?> submit(String roleId, String permissionId, bool granted) async {
    state = const AsyncLoading<Role?>();
    final result = await AsyncValue.guard(
      () => ref
          .read(roleRepositoryProvider)
          .setPermission(roleId, permissionId, granted),
    );
    if (!ref.mounted) return null;
    state = result;
    return result.value;
  }
}

@riverpod
class DeleteRoleController extends _$DeleteRoleController {
  @override
  FutureOr<void> build() {}

  Future<bool> submit(String id) async {
    state = const AsyncLoading<void>();
    final result = await AsyncValue.guard(
      () => ref.read(roleRepositoryProvider).delete(id),
    );
    if (!ref.mounted) return false;
    state = result;
    return !result.hasError;
  }
}
