import 'package:flutter_test/flutter_test.dart';
import 'package:microcollect/core/errors/app_exception.dart';
import 'package:microcollect/data/dev/dev_settings.dart';
import 'package:microcollect/data/dev/latency_profile.dart';
import 'package:microcollect/data/dev/mock_op.dart';
import 'package:microcollect/data/mock/mock_gateway.dart';

void main() {
  group('MockGateway.call', () {
    test(
      'returns the action result when nothing is configured to fail',
      () async {
        final gateway = MockGateway(
          () => const DevSettings(latency: LatencyProfile.instant),
        );

        final result = await gateway.call(MockOp.read, () => 42);

        expect(result, 42);
      },
    );

    test('throws the injected failure instead of running the action', () async {
      final gateway = MockGateway(
        () => const DevSettings(
          latency: LatencyProfile.instant,
          failingOps: {MockOp.payment},
        ),
      );

      var actionRan = false;
      await expectLater(
        gateway.call(MockOp.payment, () {
          actionRan = true;
          return 'receipt';
        }),
        throwsA(isA<PaymentFailedException>()),
      );
      expect(actionRan, isFalse);
    });

    test('leaves unrelated operations unaffected by a failing op', () async {
      final gateway = MockGateway(
        () => const DevSettings(
          latency: LatencyProfile.instant,
          failingOps: {MockOp.payment},
        ),
      );

      final result = await gateway.call(MockOp.read, () => 'ok');

      expect(result, 'ok');
    });

    test(
      'rejects a sync while offline even without an explicit failure',
      () async {
        final gateway = MockGateway(
          () => const DevSettings(
            isOnline: false,
            latency: LatencyProfile.instant,
          ),
        );

        await expectLater(
          gateway.call(MockOp.sync, () => 'synced'),
          throwsA(isA<NetworkException>()),
        );
      },
    );

    test('still allows a plain read while offline', () async {
      final gateway = MockGateway(
        () =>
            const DevSettings(isOnline: false, latency: LatencyProfile.instant),
      );

      final result = await gateway.call(MockOp.read, () => 'cached');

      expect(result, 'cached');
    });

    test(
      'reads the latest settings on every call rather than caching them',
      () async {
        var online = false;
        final gateway = MockGateway(
          () => DevSettings(isOnline: online, latency: LatencyProfile.instant),
        );

        await expectLater(
          gateway.call(MockOp.sync, () => 'synced'),
          throwsA(isA<NetworkException>()),
        );

        online = true;
        final result = await gateway.call(MockOp.sync, () => 'synced');
        expect(result, 'synced');
      },
    );

    test('waits at least the configured latency before resolving', () async {
      final gateway = MockGateway(
        () => const DevSettings(latency: LatencyProfile.fast),
      );

      final stopwatch = Stopwatch()..start();
      await gateway.call(MockOp.read, () => 'done');
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(140));
    });
  });
}
