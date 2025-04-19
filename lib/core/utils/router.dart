import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/auth/screens/sign_in_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/profile_edit_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../services/auth_provider.dart';
import '../services/service_locator.dart';
import '../theme/theme_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import 'constants.dart';
import 'responsive_layout.dart';

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
      GoRoute(
        path: '/sign-in',
        name: 'sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        name: 'sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),

      // App routes
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavBar(location: state.uri.path, child: child);
        },
        routes: [
          GoRoute(path: '/', name: 'root', redirect: (_, __) => '/dashboard'),
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/activity',
            name: 'activity',
            builder:
                (context, state) => const Scaffold(
                  body: Center(child: Text('Activity Screen')),
                ),
          ),
          GoRoute(
            path: '/chat',
            name: 'chat',
            builder:
                (context, state) =>
                    const Scaffold(body: Center(child: Text('Chat Screen'))),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'profile-edit',
                builder: (context, state) => const ProfileEditScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}

// Scaffold with bottom navigation bar
class ScaffoldWithNavBar extends StatelessWidget {
  final String location;
  final Widget child;

  const ScaffoldWithNavBar({
    super.key,
    required this.location,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current tab index based on the location
    int currentIndex = 0;
    if (location.startsWith('/dashboard')) {
      currentIndex = 0;
    } else if (location.startsWith('/orders')) {
      currentIndex = 1;
    } else if (location.startsWith('/wishlist')) {
      currentIndex = 2;
    } else if (location.startsWith('/wallet')) {
      currentIndex = 3;
    } else if (location.startsWith('/profile')) {
      currentIndex = 4;
    }

    // For desktop and larger screens, we show a different layout
    if (DeviceScreenType.isDesktop(context)) {
      return Scaffold(
        body: Row(
          children: [
            // Side navigation for desktop
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                switch (index) {
                  case 0:
                    context.go('/dashboard');
                    break;
                  case 1:
                    context.go('/orders');
                    break;
                  case 2:
                    context.go('/wishlist');
                    break;
                  case 3:
                    context.go('/wallet');
                    break;
                  case 4:
                    context.go('/profile');
                    break;
                }
              },
              labelType: NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(
                  icon: Image.asset(
                    'assets/icons/Home.png',
                    width: 24,
                    height: 24,
                    color: Colors.grey,
                  ),
                  selectedIcon: Image.asset(
                    'assets/icons/Home.png',
                    width: 24,
                    height: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: const Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Image.asset(
                    'assets/icons/Document.png',
                    width: 24,
                    height: 24,
                    color: Colors.grey,
                  ),
                  selectedIcon: Image.asset(
                    'assets/icons/Document.png',
                    width: 24,
                    height: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: const Text('Orders'),
                ),
                NavigationRailDestination(
                  icon: Image.asset(
                    'assets/icons/wishlist.png',
                    width: 24,
                    height: 24,
                    color: Colors.grey,
                  ),
                  selectedIcon: Image.asset(
                    'assets/icons/wishlist.png',
                    width: 24,
                    height: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: const Text('Wishlist'),
                ),
                NavigationRailDestination(
                  icon: Image.asset(
                    'assets/icons/Wallet.png',
                    width: 24,
                    height: 24,
                    color: Colors.grey,
                  ),
                  selectedIcon: Image.asset(
                    'assets/icons/Wallet.png',
                    width: 24,
                    height: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: const Text('E-Wallet'),
                ),
                NavigationRailDestination(
                  icon: Image.asset(
                    'assets/icons/Profile.png',
                    width: 24,
                    height: 24,
                    color: Colors.grey,
                  ),
                  selectedIcon: Image.asset(
                    'assets/icons/Profile.png',
                    width: 24,
                    height: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: const Text('Profile'),
                ),
              ],
            ),
            // Vertical divider
            VerticalDivider(
              thickness: 1,
              width: 1,
              color: Colors.grey.withOpacity(0.2),
            ),
            // Main content area
            Expanded(child: ResponsiveContainer(child: child)),
          ],
        ),
      );
    }

    // For mobile and tablet, we show a bottom navigation bar
    return Scaffold(
      body: ResponsiveContainer(
        applyHorizontalConstraint: DeviceScreenType.isTablet(context),
        child: child,
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: currentIndex),
    );
  }
}
