import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/remote/api_client.dart';

part 'auth_controller.g.dart';

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'],
    email: json['email'] as String,
    name: json['name'] as String,
    role: json['role'] as String,
  );

  final dynamic id;
  final String email;
  final String name;
  final String role;
}

class AuthState {
  const AuthState({this.token, this.user});

  final String? token;
  final AuthUser? user;

  bool get isAuthenticated => token != null;
}

/// In-memory session state for the remote backend: holds the JWT issued
/// by POST /auth/login and the decoded user, for as long as the app is
/// running. Nothing here is persisted to disk - closing the app signs
/// the user out, same as the mock backend having no concept of a session
/// at all today.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthState build() => const AuthState();

  Future<void> login(String email, String password) async {
    final client = ApiClient();
    final json = await client.post(
      '/auth/login',
      body: {'email': email, 'password': password},
    );
    state = AuthState(
      token: json['token'] as String,
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  void logout() => state = const AuthState();
}
