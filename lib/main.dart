import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'viewmodels/theme_provider.dart';
import 'viewmodels/auth_provider.dart';
import 'viewmodels/cart_provider.dart';
import 'data/repositories/restaurant_repository.dart';
import 'data/repositories/order_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        Provider(create: (_) => RestaurantRepository()),
        Provider(create: (_) => OrderRepository()),
      ],
      child: const AppRoot(),
    );
  }
}

class AppRoot extends HookWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      title: 'iFood Clone',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
