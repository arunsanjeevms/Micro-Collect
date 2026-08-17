import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';

class MicroCollectApp extends ConsumerWidget {
  const MicroCollectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'MicroCollect',
      theme: AppTheme.light, // Uses the Growth & Trust theme we created
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
    );
  }
}
