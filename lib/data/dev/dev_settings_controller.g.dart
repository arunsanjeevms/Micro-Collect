// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dev_settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The dev menu's entire write surface. Unlike the repository providers,
/// this needs no ProviderScope override - DevSettings only exists because
/// the backend is mocked, so it's always a real provider, never a seam.

@ProviderFor(DevSettingsController)
final devSettingsControllerProvider = DevSettingsControllerProvider._();

/// The dev menu's entire write surface. Unlike the repository providers,
/// this needs no ProviderScope override - DevSettings only exists because
/// the backend is mocked, so it's always a real provider, never a seam.
final class DevSettingsControllerProvider
    extends $NotifierProvider<DevSettingsController, DevSettings> {
  /// The dev menu's entire write surface. Unlike the repository providers,
  /// this needs no ProviderScope override - DevSettings only exists because
  /// the backend is mocked, so it's always a real provider, never a seam.
  DevSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'devSettingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$devSettingsControllerHash();

  @$internal
  @override
  DevSettingsController create() => DevSettingsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DevSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DevSettings>(value),
    );
  }
}

String _$devSettingsControllerHash() =>
    r'e2eab52430ddaca6dd7e79582c107e8c1ad2b62d';

/// The dev menu's entire write surface. Unlike the repository providers,
/// this needs no ProviderScope override - DevSettings only exists because
/// the backend is mocked, so it's always a real provider, never a seam.

abstract class _$DevSettingsController extends $Notifier<DevSettings> {
  DevSettings build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DevSettings, DevSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DevSettings, DevSettings>,
              DevSettings,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
