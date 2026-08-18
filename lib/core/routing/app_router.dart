import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/dashboard/dashboard_screen.dart';
import '../../features/borrowers/borrowers_screen.dart';
import '../../features/borrowers/borrower_detail_screen.dart';
import '../../features/borrowers/add_borrower_screen.dart';
import '../../features/loans/loan_detail_screen.dart';
import '../../features/loans/create_loan_screen.dart';
import '../../features/collections/collections_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../widgets/app_bottom_nav.dart';

part 'app_router.g.dart';

// Navigation keys for preserving state across tabs
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // ─── Shell Route with Bottom Navigation ──────────────────
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return _AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DashboardScreen()),
          ),
          GoRoute(
            path: '/borrowers',
            pageBuilder: (context, state) => NoTransitionPage(
              child: BorrowersScreen(
                onBorrowerTap: (id) => context.push('/borrowers/$id'),
              ),
            ),
          ),
          GoRoute(
            path: '/collections',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CollectionsScreen()),
          ),
          GoRoute(
            path: '/reports',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ReportsScreen()),
          ),
        ],
      ),

      // ─── Detail Routes (outside shell, full-screen) ──────────
      GoRoute(
        path: '/borrowers/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            BorrowerDetailScreen(borrowerId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/borrowers/add',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddBorrowerScreen(),
      ),
      GoRoute(
        path: '/loans/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            LoanDetailScreen(loanId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/loans/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateLoanScreen(),
      ),
    ],
  );
}

/// App Shell — wraps tab pages with bottom navigation
class _AppShell extends StatelessWidget {
  final Widget child;

  const _AppShell({required this.child});

  static const _paths = ['/', '/borrowers', '/collections', '/reports'];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _paths.length; i++) {
      if (location == _paths[i]) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex(context),
        onTap: (index) => context.go(_paths[index]),
      ),
    );
  }
}
