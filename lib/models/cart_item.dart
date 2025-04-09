import 'menu_item.dart';

class CartItem {
  final MenuItem menuItem;
  final int quantity;
  final String? observation;

  CartItem({
    required this.menuItem,
    required this.quantity,
    this.observation,
  });

  double get totalPrice => menuItem.price * quantity;

  CartItem copyWith({
    MenuItem? menuItem,
    int? quantity,
    String? observation,
  }) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      observation: observation ?? this.observation,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      menuItem: MenuItem.fromJson(json['menuItem']),
      quantity: json['quantity'],
      observation: json['observation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItem.toJson(),
      'quantity': quantity,
      'observation': observation,
    };
  }
} 