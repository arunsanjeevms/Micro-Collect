import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backend_mode.g.dart';

/// Whether the app is wired to the real Node/MySQL backend (which
/// requires a login) or the mock backend (which has no concept of a
/// session). Defaults to false; remoteBackendOverrides() in
/// lib/data/remote/remote_bindings.dart overrides this to true. The
/// router's redirect logic reads this to decide whether an
/// unauthenticated AuthController state should send the user to /login.
@Riverpod(keepAlive: true)
bool usesRemoteBackend(Ref ref) => false;
