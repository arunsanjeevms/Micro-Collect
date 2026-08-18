import '../../core/errors/app_exception.dart';
import '../dev/dev_settings.dart';
import '../dev/mock_op.dart';

/// Every mock repository routes its calls through this one place, so
/// latency and failure injection (the dev menu's job) lives in exactly one
/// spot instead of being reimplemented per repository.
class MockGateway {
  MockGateway(this._settings);

  /// A closure rather than a captured value, so every call reads the
  /// *current* dev settings - repositories are constructed once, but the
  /// dev menu can flip settings at any time afterwards.
  final DevSettings Function() _settings;

  Future<T> call<T>(MockOp op, T Function() action) async {
    final settings = _settings();

    await Future<void>.delayed(settings.latencyFor(op));

    final failure = settings.failureFor(op);
    if (failure != null) throw failure;

    if (!settings.isOnline && op == MockOp.sync) {
      throw const NetworkException();
    }

    return action();
  }
}
