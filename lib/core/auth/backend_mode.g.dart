// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend_mode.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the app is wired to the real Node/MySQL backend (which
/// requires a login) or the mock backend (which has no concept of a
/// session). Defaults to false; remoteBackendOverrides() in
/// lib/data/remote/remote_bindings.dart overrides this to true. The
/// router's redirect logic reads this to decide whether an
/// unauthenticated AuthController state should send the user to /login.

@ProviderFor(usesRemoteBackend)
final usesRemoteBackendProvider = UsesRemoteBackendProvider._();

/// Whether the app is wired to the real Node/MySQL backend (which
/// requires a login) or the mock backend (which has no concept of a
/// session). Defaults to false; remoteBackendOverrides() in
/// lib/data/remote/remote_bindings.dart overrides this to true. The
/// router's redirect logic reads this to decide whether an
/// unauthenticated AuthController state should send the user to /login.

final class UsesRemoteBackendProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the app is wired to the real Node/MySQL backend (which
  /// requires a login) or the mock backend (which has no concept of a
  /// session). Defaults to false; remoteBackendOverrides() in
  /// lib/data/remote/remote_bindings.dart overrides this to true. The
  /// router's redirect logic reads this to decide whether an
  /// unauthenticated AuthController state should send the user to /login.
  UsesRemoteBackendProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usesRemoteBackendProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usesRemoteBackendHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return usesRemoteBackend(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$usesRemoteBackendHash() => r'401d92d7d95f66a3123e7fc2b8458f93f0e0e5e4';
