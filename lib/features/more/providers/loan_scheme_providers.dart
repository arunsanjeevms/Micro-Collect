import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/data_revision.dart';
import '../../../core/data/entity_kind.dart';
import '../../../core/models/loan_scheme.dart';
import '../../../data/repositories/loan_scheme_repository.dart';
import '../../../data/repositories/repository_providers.dart';

part 'loan_scheme_providers.g.dart';

@riverpod
Future<List<LoanScheme>> loanSchemes(Ref ref) {
  ref.watch(dataRevisionProvider(EntityKind.loanScheme));
  return ref.watch(loanSchemeRepositoryProvider).fetchAll();
}

@riverpod
class CreateLoanSchemeController extends _$CreateLoanSchemeController {
  @override
  FutureOr<LoanScheme?> build() => null;

  Future<LoanScheme?> submit(LoanSchemeDraft draft) async {
    state = const AsyncLoading<LoanScheme?>();
    final result = await AsyncValue.guard(
      () => ref.read(loanSchemeRepositoryProvider).create(draft),
    );
    if (!ref.mounted) return null;
    state = result;
    return result.value;
  }
}

@riverpod
class SetLoanSchemeActiveController extends _$SetLoanSchemeActiveController {
  @override
  FutureOr<LoanScheme?> build() => null;

  Future<LoanScheme?> submit(String id, bool active) async {
    state = const AsyncLoading<LoanScheme?>();
    final result = await AsyncValue.guard(
      () => ref.read(loanSchemeRepositoryProvider).setActive(id, active),
    );
    if (!ref.mounted) return null;
    state = result;
    return result.value;
  }
}

@riverpod
class DeleteLoanSchemeController extends _$DeleteLoanSchemeController {
  @override
  FutureOr<void> build() {}

  Future<bool> submit(String id) async {
    state = const AsyncLoading<void>();
    final result = await AsyncValue.guard(
      () => ref.read(loanSchemeRepositoryProvider).delete(id),
    );
    if (!ref.mounted) return false;
    state = result;
    return !result.hasError;
  }
}
