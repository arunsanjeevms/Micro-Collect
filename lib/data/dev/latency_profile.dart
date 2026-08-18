import 'mock_op.dart';

/// How long a simulated call takes, so loading states (SkeletonLoader,
/// AsyncValueView's loading branch) are actually reachable in the demo
/// instead of resolving before a frame is even drawn.
enum LatencyProfile { instant, fast, realistic, slow }

extension LatencyProfileTiming on LatencyProfile {
  Duration forOp(MockOp op) {
    final scale = switch (op) {
      MockOp.read => 1.0,
      MockOp.write => 1.2,
      MockOp.payment => 1.4,
      MockOp.sync => 1.6,
      MockOp.print => 1.2,
      MockOp.auth => 1.0,
    };
    final baseMs = switch (this) {
      LatencyProfile.instant => 0,
      LatencyProfile.fast => 150,
      LatencyProfile.realistic => 500,
      LatencyProfile.slow => 1500,
    };
    return Duration(milliseconds: (baseMs * scale).round());
  }
}
