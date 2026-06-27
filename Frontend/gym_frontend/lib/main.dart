import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'dashboard_screen.dart';
import 'components_screen.dart';
import 'products_screen.dart';
import 'account_settings_screen.dart';
import 'session_logs_screen.dart';
import 'low_stock_screen.dart';
import 'stock_movements_screen.dart'; // <-- 1. ADD THIS IMPORT
import 'login_screen.dart';
import 'signup_screen.dart';
import 'theme.dart';
import 'providers/locale_provider.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();

    // theme setup
    final themeStr = prefs.getString('theme') ?? AppTheme.minimalistDark.name;
    final selectedTheme = AppTheme.values.firstWhere(
      (e) => e.name == themeStr,
      orElse: () => AppTheme.minimalistDark,
    );
    themeNotifier.value = appThemeData[selectedTheme]!;

    // load saved locale
    final savedLocale = await LocaleProvider.getSavedLocale();

    runApp(
      ChangeNotifierProvider(
        create: (_) => LocaleProvider(savedLocale),
        child: const GymApp(),
      ),
    );
  } catch (e, st) {
    print('Error initializing theme: $e\n$st');
    themeNotifier.value = appThemeData[AppTheme.minimalistDark]!;
    runApp(
      ChangeNotifierProvider(
        create: (_) => LocaleProvider(null),
        child: const GymApp(),
      ),
    );
  }
}

class GymApp extends StatelessWidget {
  const GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) {
        final localeProvider = Provider.of<LocaleProvider>(context);
        return MaterialApp(
          title: 'Gym Inventory',
          theme: theme,
          debugShowCheckedModeBanner: false,

          // localization config
          locale: localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,

          initialRoute: '/login',
          routes: {
            '/login': (context) => LoginScreen(),
            '/signup': (context) => SignupScreen(),
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/dashboard':
                final user = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(builder: (_) => DashboardScreen(user: user));
              case '/components':
                final user = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(builder: (_) => ComponentsScreen(user: user));
              case '/products':
                final user = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(builder: (_) => ProductsScreen(user: user));
              
              // --- 2. ADD THIS NEW ROUTE CASE ---
              case '/stock-movements':
                final user = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(builder: (_) => StockMovementsScreen(user: user));
              // ------------------------------------

              case '/session-logs':
                final user = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(builder: (_) => SessionLogsScreen(user: user));
              case '/low-stock':
                final user = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(builder: (_) => LowStockScreen(user: user));
              case '/account':
                final user = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (_) => AccountSettingsScreen(user: user, userId: user['id']),
                );
              default:
                return null;
            }
          },
        );
      },
    );
  }
}