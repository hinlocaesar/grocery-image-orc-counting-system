import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/budget_provider.dart';
import '../providers/router_refresh_provider.dart';
import '../screens/basket_total_screen.dart';
import '../screens/budget_exceeded_screen.dart';
import '../screens/budget_setup_screen.dart';
import '../screens/history_screen.dart';
import '../screens/scan_item_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(routerRefreshProvider);
  final hasBudget = ref.watch(budgetProvider) != null;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: hasBudget ? '/home' : '/setup',
    refreshListenable: refresh,
    redirect: (context, state) {
      final budget = ref.read(budgetProvider);
      final location = state.matchedLocation;
      final isSetup = location == '/setup';
      final isAdjusting = state.uri.queryParameters['adjust'] == 'true';

      if (budget == null && !isSetup) {
        return '/setup';
      }

      if (budget != null && isSetup && !isAdjusting) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/setup',
        builder: (context, state) => const BudgetSetupScreen(),
      ),
      GoRoute(
        path: '/budget-exceeded',
        builder: (context, state) => const BudgetExceededScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final index = _shellIndexForLocation(state.matchedLocation);
          return MainShell(currentIndex: index, child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BasketTotalScreen(),
            ),
          ),
          GoRoute(
            path: '/history',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HistoryScreen(),
            ),
          ),
          GoRoute(
            path: '/scan',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ScanItemScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});

int _shellIndexForLocation(String location) {
  if (location.startsWith('/history')) return 1;
  if (location.startsWith('/scan')) return 2;
  if (location.startsWith('/settings')) return 3;
  return 0;
}
