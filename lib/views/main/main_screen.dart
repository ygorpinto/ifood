import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/cart_provider.dart';

class MainScreen extends HookWidget {
  final Widget child;

  const MainScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final cartProvider = context.watch<CartProvider>();
    
    final int selectedIndex = useMemoized(() {
      if (currentLocation.startsWith('/cart')) {
        return 1;
      } else if (currentLocation.startsWith('/orders')) {
        return 2;
      } else {
        return 0;
      }
    }, [currentLocation]);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/cart');
              break;
            case 2:
              context.go('/orders');
              break;
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: cartProvider.itemCount > 0,
              label: Text(
                cartProvider.itemCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Carrinho',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pedidos',
          ),
        ],
      ),
    );
  }
} 