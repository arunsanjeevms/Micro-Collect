// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// In-memory session state for the remote backend: holds the JWT issued
/// by POST /auth/login and the decoded user, for as long as the app is
/// running. Nothing here is persisted to disk - closing the app signs
/// the user out, same as the mock backend having no concept of a session
/// at all today.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// In-memory session state for the remote backend: holds the JWT issued
/// by POST /auth/login and the decoded user, for as long as the app is
/// running. Nothing here is persisted to disk - closing the app signs
/// the user out, same as the mock backend having no concept of a session
/// at all today.
final class AuthControllerProvider
    extends $NotifierProvider<AuthController, AuthState> {
  /// In-memory session state for the remote backend: holds the JWT issued
  /// by POST /auth/login and the decoded user, for as long as the app is
  /// running. Nothing here is persisted to disk - closing the app signs
  /// the user out, same as the mock backend having no concept of a session
  /// at all today.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authControllerHash() => r'c4eef3124b0eefa8fbc2c606d9482d0b0a7efaf7';

/// In-memory session state for the remote backend: holds the JWT issued
/// by POST /auth/login and the decoded user, for as long as the app is
/// running. Nothing here is persisted to disk - closing the app signs
/// the user out, same as the mock backend having no concept of a session
/// at all today.

abstract class _$AuthController extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
