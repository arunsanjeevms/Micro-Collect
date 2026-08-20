// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(areas)
final areasProvider = AreasProvider._();

final class AreasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Area>>,
          List<Area>,
          FutureOr<List<Area>>
        >
    with $FutureModifier<List<Area>>, $FutureProvider<List<Area>> {
  AreasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'areasProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$areasHash();

  @$internal
  @override
  $FutureProviderElement<List<Area>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Area>> create(Ref ref) {
    return areas(ref);
  }
}

String _$areasHash() => r'e765af24ac345bf196b4f74c42d5e261283b7f39';

@ProviderFor(CreateAreaController)
final createAreaControllerProvider = CreateAreaControllerProvider._();

final class CreateAreaControllerProvider
    extends $AsyncNotifierProvider<CreateAreaController, Area?> {
  CreateAreaControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createAreaControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createAreaControllerHash();

  @$internal
  @override
  CreateAreaController create() => CreateAreaController();
}

String _$createAreaControllerHash() =>
    r'2f2e2851bb0bbdf799a1831b9c26d18eca431deb';

abstract class _$CreateAreaController extends $AsyncNotifier<Area?> {
  FutureOr<Area?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Area?>, Area?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Area?>, Area?>,
              AsyncValue<Area?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(UpdateAreaController)
final updateAreaControllerProvider = UpdateAreaControllerProvider._();

final class UpdateAreaControllerProvider
    extends $AsyncNotifierProvider<UpdateAreaController, Area?> {
  UpdateAreaControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateAreaControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateAreaControllerHash();

  @$internal
  @override
  UpdateAreaController create() => UpdateAreaController();
}

String _$updateAreaControllerHash() =>
    r'161d1c66c85fea8f01d7405f625aa4dee55a5171';

abstract class _$UpdateAreaController extends $AsyncNotifier<Area?> {
  FutureOr<Area?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Area?>, Area?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Area?>, Area?>,
              AsyncValue<Area?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(DeleteAreaController)
final deleteAreaControllerProvider = DeleteAreaControllerProvider._();

final class DeleteAreaControllerProvider
    extends $AsyncNotifierProvider<DeleteAreaController, void> {
  DeleteAreaControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteAreaControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteAreaControllerHash();

  @$internal
  @override
  DeleteAreaController create() => DeleteAreaController();
}

String _$deleteAreaControllerHash() =>
    r'499ceadbb2bca2bd3768272cfd1535fb40adc44a';

abstract class _$DeleteAreaController extends $AsyncNotifier<void> {
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
