import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/services/auth_provider.dart';
import 'core/services/service_locator.dart';
import 'core/services/user_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/utils/constants.dart';
import 'core/utils/router.dart';
import 'core/utils/system_ui_helper.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initial setup for system UI (will be updated based on theme later)
  SystemUIHelper.setOverlayStyleForBrightness(Brightness.light);

  try {
    // Initialize service locator
    setupLocator();

    // Create initial instances
    final authProvider = locator<AuthProvider>();
    final userProvider = locator<UserProvider>();
    final themeProvider = locator<ThemeProvider>();

    debugPrint('Service locator initialized successfully');
    debugPrint('Auth provider initialized, status: ${authProvider.status}');
    debugPrint(
      'User provider initialized, users count: ${userProvider.users.length}',
    );

    runApp(const MyApp());
  } catch (e) {
    debugPrint('Error initializing app: $e');
    // Run a minimal app that shows the error
    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text('Error initializing app: $e'))),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<ThemeProvider>()),
        ChangeNotifierProvider(create: (_) => locator<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => locator<UserProvider>()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          // Apply correct theme for system UI on theme changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              final brightness =
                  themeProvider.isDarkMode ? Brightness.dark : Brightness.light;
              SystemUIHelper.setOverlayStyleForBrightness(brightness);
            }
          });

          return MaterialApp.router(
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
