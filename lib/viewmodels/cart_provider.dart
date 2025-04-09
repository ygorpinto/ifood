import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../models/restaurant.dart';

class CartProvider extends ChangeNotifier {
  Restaurant? _restaurant;
  final List<CartItem> _items = [];

  Restaurant? get restaurant => _restaurant;
  List<CartItem> get items => _items;
  bool get isEmpty => _items.isEmpty;

  double get subtotal {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee {
    return _restaurant?.deliveryFee ?? 0.0;
  }

  double get total {
    return subtotal + deliveryFee;
  }

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void clear() {
    _restaurant = null;
    _items.clear();
    notifyListeners();
  }

  bool canAddFromRestaurant(Restaurant newRestaurant) {
    if (_restaurant == null || _items.isEmpty) {
      return true;
    }
    return _restaurant!.id == newRestaurant.id;
  }

  void addItem(Restaurant restaurant, MenuItem menuItem, {int quantity = 1, String? observation}) {
    // Verifica se pode adicionar itens de outro restaurante
    if (!canAddFromRestaurant(restaurant)) {
      throw Exception('Não é possível adicionar itens de restaurantes diferentes');
    }

    // Define o restaurante se for o primeiro item
    if (_restaurant == null) {
      _restaurant = restaurant;
    }

    // Verifica se o item já existe no carrinho
    final existingIndex = _items.indexWhere(
      (item) => item.menuItem.id == menuItem.id && item.observation == observation,
    );

    if (existingIndex >= 0) {
      // Se o item já existe, incrementa a quantidade
      final existingItem = _items[existingIndex];
      final newQuantity = existingItem.quantity + quantity;
      _items[existingIndex] = existingItem.copyWith(quantity: newQuantity);
    } else {
      // Se não existe, adiciona novo item
      _items.add(
        CartItem(
          menuItem: menuItem,
          quantity: quantity,
          observation: observation,
        ),
      );
    }

    notifyListeners();
  }

  void updateItemQuantity(CartItem cartItem, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(cartItem);
      return;
    }

    final index = _items.indexWhere(
      (item) => item.menuItem.id == cartItem.menuItem.id && item.observation == cartItem.observation,
    );

    if (index >= 0) {
      _items[index] = cartItem.copyWith(quantity: newQuantity);
      notifyListeners();
    }
  }

  void removeItem(CartItem cartItem) {
    _items.removeWhere(
      (item) => item.menuItem.id == cartItem.menuItem.id && item.observation == cartItem.observation,
    );

    if (_items.isEmpty) {
      _restaurant = null;
    }

    notifyListeners();
  }

  bool hasItem(MenuItem menuItem) {
    return _items.any((item) => item.menuItem.id == menuItem.id);
  }

  int getItemQuantity(MenuItem menuItem) {
    if (!hasItem(menuItem)) return 0;
    return _items
        .where((item) => item.menuItem.id == menuItem.id)
        .fold(0, (sum, item) => sum + item.quantity);
  }
} 