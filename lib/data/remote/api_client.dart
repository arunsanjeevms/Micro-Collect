import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import '../../core/errors/app_exception.dart';

/// The base URL for the MicroCollect API. Android emulators can't reach
/// the host machine's `localhost` directly - `10.0.2.2` is the emulator's
/// alias for it. iOS simulators, web, and desktop all share the host's
/// network namespace, so plain `localhost` works there.
String _defaultBaseUrl() {
  if (kIsWeb) return 'http://localhost:4000';
  if (Platform.isAndroid) return 'http://10.0.2.2:4000';
  return 'http://localhost:4000';
}

/// Thin HTTP wrapper around the Node backend: attaches the bearer token,
/// decodes JSON, and translates every non-2xx response into the same
/// AppException taxonomy the mock backend throws, so screens don't need to
/// know which backend they're talking to.
class ApiClient {
  ApiClient({String? baseUrl, http.Client? client, this.tokenProvider})
    : baseUrl = baseUrl ?? _defaultBaseUrl(),
      _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  /// Reads the current auth token on every call, rather than being fixed
  /// at construction - the token can change (login/logout) after this
  /// client is built once at app startup.
  final String? Function()? tokenProvider;

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    final token = tokenProvider?.call();
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    return _send(() => _client.get(uri, headers: _headers));
  }

  Future<dynamic> post(String path, {Object? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    return _send(
      () => _client.post(uri, headers: _headers, body: jsonEncode(body ?? {})),
    );
  }

  Future<dynamic> patch(String path, {Object? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    return _send(
      () => _client.patch(uri, headers: _headers, body: jsonEncode(body ?? {})),
    );
  }

  Future<dynamic> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    return _send(() => _client.delete(uri, headers: _headers));
  }

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    http.Response response;
    try {
      response = await request();
    } on SocketException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    }

    final decoded = response.body.isEmpty ? null : jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    final message = (decoded is Map && decoded['error'] is Map)
        ? (decoded['error']['message'] as String? ?? 'Request failed')
        : 'Request failed';
    final code = (decoded is Map && decoded['error'] is Map)
        ? decoded['error']['code'] as String?
        : null;

    switch (response.statusCode) {
      case 401:
        throw PermissionException(message);
      case 403:
        throw PermissionException(message);
      case 404:
        // NotFoundException always renders '$kind $id not found' - the
        // server's message is already exactly that shape ("Loan L999 not
        // found"), so pass it as the kind with an empty id rather than
        // re-deriving kind/id here.
        throw NotFoundException(
          message.replaceAll(RegExp(r'\s+not found$'), ''),
          '',
        );
      case 409:
        throw code == 'payment_failed'
            ? PaymentFailedException(message)
            : ValidationException(message);
      case 422:
        throw ValidationException(message);
      default:
        throw NetworkException(message);
    }
  }
}
