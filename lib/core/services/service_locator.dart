import 'package:get_it/get_it.dart';

import 'auth_provider.dart';
import 'mock_data_service.dart';
import 'user_provider.dart';
import '../theme/theme_provider.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Services
  locator.registerLazySingleton<MockDataService>(() => MockDataService());

  // Providers
  locator.registerLazySingleton<AuthProvider>(() => AuthProvider());
  locator.registerLazySingleton<UserProvider>(() => UserProvider());
  locator.registerLazySingleton<ThemeProvider>(() => ThemeProvider());
}
