import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/errors/app_exception.dart';
import 'latency_profile.dart';
import 'mock_op.dart';

part 'dev_settings.freezed.dart';

/// Simulation knobs for the mock backend. This whole file is deleted along
/// with the rest of lib/data/mock the day a real backend replaces it - none
/// of it is a real app setting.
@freezed
abstract class DevSettings with _$DevSettings {
  const DevSettings._();

  const factory DevSettings({
    @Default(true) bool isOnline,
    @Default(LatencyProfile.realistic) LatencyProfile latency,
    @Default(<MockOp>{}) Set<MockOp> failingOps,
  }) = _DevSettings;

  Duration latencyFor(MockOp op) => latency.forOp(op);

  AppException? failureFor(MockOp op) {
    if (!failingOps.contains(op)) return null;
    return switch (op) {
      MockOp.payment => const PaymentFailedException(),
      MockOp.print => const PrinterException(),
      MockOp.sync => const SyncException(),
      MockOp.read || MockOp.write || MockOp.auth => const NetworkException(),
    };
  }
}
