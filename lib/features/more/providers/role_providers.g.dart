// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(roles)
final rolesProvider = RolesProvider._();

final class RolesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Role>>,
          List<Role>,
          FutureOr<List<Role>>
        >
    with $FutureModifier<List<Role>>, $FutureProvider<List<Role>> {
  RolesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rolesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rolesHash();

  @$internal
  @override
  $FutureProviderElement<List<Role>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Role>> create(Ref ref) {
    return roles(ref);
  }
}

String _$rolesHash() => r'f3081131a37722c79c8b55367699956508f3d45a';

@ProviderFor(CreateRoleController)
final createRoleControllerProvider = CreateRoleControllerProvider._();

final class CreateRoleControllerProvider
    extends $AsyncNotifierProvider<CreateRoleController, Role?> {
  CreateRoleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createRoleControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createRoleControllerHash();

  @$internal
  @override
  CreateRoleController create() => CreateRoleController();
}

String _$createRoleControllerHash() =>
    r'5b5fc78940441a1e3d43daf29b967d965e8734f2';

abstract class _$CreateRoleController extends $AsyncNotifier<Role?> {
  FutureOr<Role?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Role?>, Role?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Role?>, Role?>,
              AsyncValue<Role?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SetRolePermissionController)
final setRolePermissionControllerProvider =
    SetRolePermissionControllerProvider._();

final class SetRolePermissionControllerProvider
    extends $AsyncNotifierProvider<SetRolePermissionController, Role?> {
  SetRolePermissionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setRolePermissionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setRolePermissionControllerHash();

  @$internal
  @override
  SetRolePermissionController create() => SetRolePermissionController();
}

String _$setRolePermissionControllerHash() =>
    r'909c4ed5b11dccd2014c8f886e0382b87ad86f9e';

abstract class _$SetRolePermissionController extends $AsyncNotifier<Role?> {
  FutureOr<Role?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Role?>, Role?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Role?>, Role?>,
              AsyncValue<Role?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(DeleteRoleController)
final deleteRoleControllerProvider = DeleteRoleControllerProvider._();

final class DeleteRoleControllerProvider
    extends $AsyncNotifierProvider<DeleteRoleController, void> {
  DeleteRoleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteRoleControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteRoleControllerHash();

  @$internal
  @override
  DeleteRoleController create() => DeleteRoleController();
}

String _$deleteRoleControllerHash() =>
    r'cff4830d6ed6cfe751cfe15024cdb92848ded8ed';

abstract class _$DeleteRoleController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
