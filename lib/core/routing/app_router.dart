import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/dashboard/dashboard_screen.dart';
import '../../features/borrowers/borrowers_screen.dart';
import '../../features/borrowers/borrower_detail_screen.dart';
import '../../features/borrowers/add_borrower_screen.dart';
import '../../features/loans/loan_detail_screen.dart';
import '../../features/loans/create_loan_screen.dart';
import '../../features/loans/borrower_loans_screen.dart';
import '../../features/loans/loan_created_screen.dart';
import '../../features/loans/loan_closure_screen.dart';
import '../../features/loans/loan_statement_screen.dart';
import '../../core/models/loan.dart';
import '../../features/collections/collections_screen.dart';
import '../../features/collections/payment_success_screen.dart';
import '../../features/collections/payment_receipt_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/reports/daily_collection_report_screen.dart';
import '../../data/repositories/collection_repository.dart';
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
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BorrowersScreen()),
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
      // Static paths must be registered before ":id" wildcards below -
      // go_router matches in declaration order, so "/borrowers/add" would
      // otherwise resolve as BorrowerDetailScreen(borrowerId: "add").
      GoRoute(
        path: '/borrowers/add',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddBorrowerScreen(),
      ),
      GoRoute(
        path: '/borrowers/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            BorrowerDetailScreen(borrowerId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/borrowers/:id/loans',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            BorrowerLoansScreen(borrowerId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/loans/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => CreateLoanScreen(
          borrowerId: state.uri.queryParameters['borrowerId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/loans/created',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            LoanCreatedScreen(loan: state.extra as Loan),
      ),
      GoRoute(
        path: '/loans/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            LoanDetailScreen(loanId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/loans/:id/close',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            LoanClosureScreen(loanId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/loans/:id/statement',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            LoanStatementScreen(loanId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/payments/success',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            PaymentSuccessScreen(receipt: state.extra as PaymentReceipt),
      ),
      GoRoute(
        path: '/payments/receipt',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            PaymentReceiptScreen(receipt: state.extra as PaymentReceipt),
      ),
      GoRoute(
        path: '/reports/daily',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DailyCollectionReportScreen(),
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
