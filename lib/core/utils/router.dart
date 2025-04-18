import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


import '../../features/dashboard/screens/dashboard_screen.dart';

import '../services/auth_provider.dart';
import '../services/service_locator.dart';
import '../theme/theme_provider.dart';
import 'constants.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authProvider = locator<AuthProvider>();
      final isLoggedIn = authProvider.isAuthenticated;

      // Debug output
      debugPrint(
        'GoRouter redirect - path: ${state.uri.path}, isLoggedIn: $isLoggedIn',
      );

      // If the user is not logged in, redirect to the sign-in page
      if (!isLoggedIn &&
          state.uri.path != '/sign-in' &&
          state.uri.path != '/sign-up') {
        debugPrint('Redirecting to /sign-in');
        return '/sign-in';
      }

      // If the user is logged in and tries to access auth pages, redirect to dashboard
      if (isLoggedIn &&
          (state.uri.path == '/sign-in' ||
              state.uri.path == '/sign-up' ||
              state.uri.path == '/')) {
        debugPrint('Redirecting to /dashboard');
        return '/dashboard';
      }

      // No redirect needed
      debugPrint('No redirect needed for ${state.uri.path}');
      return null;
    },
    refreshListenable: locator<AuthProvider>(),
    routes: [
      // Auth routes
    

      // App routes
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(path: '/', name: 'root', redirect: (_, __) => '/dashboard'),
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
        ],
      ),
    ],
  );
}

// Scaffold with bottom navigation bar
class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      AppConstants.appName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                selected: GoRouterState.of(
                  context,
                ).uri.path.contains('/dashboard'),
                selectedTileColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1),
                selectedColor: Theme.of(context).colorScheme.primary,
                leading: const Icon(Icons.dashboard_outlined),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/dashboard');
                },
              ),
              ListTile(
                selected: GoRouterState.of(
                  context,
                ).uri.path.contains('/profile'),
                selectedTileColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1),
                selectedColor: Theme.of(context).colorScheme.primary,
                leading: const Icon(Icons.person_outline),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/profile');
                },
              ),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) {
                  return ListTile(
                    leading: const Icon(Icons.dark_mode),
                    onTap: () {
                      themeProvider.toggleTheme();
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  await locator<AuthProvider>().signOut();
                  if (context.mounted) {
                    context.go('/sign-in');
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      body: child,
    );
  }
}
