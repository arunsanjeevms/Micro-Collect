import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/remote/remote_bindings.dart';

// import 'data/mock/mock_bindings.dart'; // swap back to mockBackendOverrides() to run without the backend/ API.

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: remoteBackendOverrides(),
      child: const MicroCollectApp(),
    ),
  );
}
