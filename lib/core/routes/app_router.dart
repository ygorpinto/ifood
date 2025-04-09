import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Importações de views
import '../../views/home/home_screen.dart';
import '../../views/restaurant/restaurant_list_screen.dart';
import '../../views/restaurant/restaurant_detail_screen.dart';
import '../../views/cart/cart_screen.dart';
import '../../views/auth/login_screen.dart';
import '../../views/auth/register_screen.dart';
import '../../views/orders/orders_screen.dart';
import '../../views/splash/splash_screen.dart';
import '../../views/main/main_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'restaurants',
                name: 'restaurants',
                builder: (context, state) {
                  final category = state.uri.queryParameters['category'];
                  return RestaurantListScreen(category: category);
                },
              ),
              GoRoute(
                path: 'restaurant/:id',
                name: 'restaurant-detail',
                builder: (context, state) {
                  final restaurantId = int.parse(state.pathParameters['id']!);
                  return RestaurantDetailScreen(restaurantId: restaurantId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/cart',
            name: 'cart',
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: '/orders',
            name: 'orders',
            builder: (context, state) => const OrdersScreen(),
          ),
        ],
      ),
    ],
  );
} 