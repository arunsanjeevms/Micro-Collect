import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:microcollect/app.dart';
import 'package:microcollect/data/dev/dev_settings.dart';
import 'package:microcollect/data/dev/dev_settings_controller.dart';
import 'package:microcollect/data/dev/latency_profile.dart';
import 'package:microcollect/data/mock/mock_bindings.dart';

/// The same backend overrides main.dart installs, plus zero simulated
/// latency and (unless overridden) no fault injection - widget tests
/// exercise the real async provider stack end to end, and
/// mockBackendOverrides() alone would leave the realistic ~500ms delay and
/// whatever the dev menu last set in place.
///
/// Pass [extraOverrides] to layer on test-specific state, e.g. a failing
/// MockOp to exercise an error state.
Widget appUnderTest({List<dynamic>? extraOverrides}) {
  return ProviderScope(
    overrides: [
      ...mockBackendOverrides(),
      devSettingsControllerProvider.overrideWithValue(
        const DevSettings(latency: LatencyProfile.instant),
      ),
      ...?extraOverrides,
    ],
    child: const MicroCollectApp(),
  );
}
