import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dev_settings.dart';
import 'latency_profile.dart';
import 'mock_op.dart';

part 'dev_settings_controller.g.dart';

/// The dev menu's entire write surface. Unlike the repository providers,
/// this needs no ProviderScope override - DevSettings only exists because
/// the backend is mocked, so it's always a real provider, never a seam.
@Riverpod(keepAlive: true)
class DevSettingsController extends _$DevSettingsController {
  @override
  DevSettings build() => const DevSettings();

  void setOnline(bool isOnline) {
    state = state.copyWith(isOnline: isOnline);
  }

  void setLatency(LatencyProfile latency) {
    state = state.copyWith(latency: latency);
  }

  void setFailing(MockOp op, bool failing) {
    final ops = {...state.failingOps};
    if (failing) {
      ops.add(op);
    } else {
      ops.remove(op);
    }
    state = state.copyWith(failingOps: ops);
  }

  void reset() => state = const DevSettings();
}
