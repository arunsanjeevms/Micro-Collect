import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/data_revision.dart';
import '../../../core/data/entity_kind.dart';
import '../../../core/models/area.dart';
import '../../../data/repositories/area_repository.dart';
import '../../../data/repositories/repository_providers.dart';

part 'area_providers.g.dart';

@riverpod
Future<List<Area>> areas(Ref ref) {
  ref.watch(dataRevisionProvider(EntityKind.area));
  return ref.watch(areaRepositoryProvider).fetchAll();
}

@riverpod
class CreateAreaController extends _$CreateAreaController {
  @override
  FutureOr<Area?> build() => null;

  Future<Area?> submit(AreaDraft draft) async {
    state = const AsyncLoading<Area?>();
    final result = await AsyncValue.guard(
      () => ref.read(areaRepositoryProvider).create(draft),
    );
    if (!ref.mounted) return null;
    state = result;
    return result.value;
  }
}

@riverpod
class UpdateAreaController extends _$UpdateAreaController {
  @override
  FutureOr<Area?> build() => null;

  Future<Area?> submit(String id, AreaPatch patch) async {
    state = const AsyncLoading<Area?>();
    final result = await AsyncValue.guard(
      () => ref.read(areaRepositoryProvider).update(id, patch),
    );
    if (!ref.mounted) return null;
    state = result;
    return result.value;
  }
}

@riverpod
class DeleteAreaController extends _$DeleteAreaController {
  @override
  FutureOr<void> build() {}

  Future<bool> submit(String id) async {
    state = const AsyncLoading<void>();
    final result = await AsyncValue.guard(
      () => ref.read(areaRepositoryProvider).delete(id),
    );
    if (!ref.mounted) return false;
    state = result;
    return !result.hasError;
  }
}
