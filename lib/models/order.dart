import 'package:intl/intl.dart';

class OrderItem {
  final int id;
  final String name;
  final double price;
  final int quantity;

  OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}

class Order {
  final int id;
  final DateTime date;
  final int restaurantId;
  final String restaurantName;
  final String restaurantLogo;
  final String status;
  final double totalAmount;
  final List<OrderItem> items;
  final double deliveryFee;
  final String paymentMethod;

  Order({
    required this.id,
    required this.date,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantLogo,
    required this.status,
    required this.totalAmount,
    required this.items,
    required this.deliveryFee,
    required this.paymentMethod,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      date: DateTime.parse(json['date']),
      restaurantId: json['restaurantId'],
      restaurantName: json['restaurantName'],
      restaurantLogo: json['restaurantLogo'],
      status: json['status'],
      totalAmount: json['totalAmount'].toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      deliveryFee: json['deliveryFee'].toDouble(),
      paymentMethod: json['paymentMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': DateFormat("yyyy-MM-ddTHH:mm:ss").format(date),
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'restaurantLogo': restaurantLogo,
      'status': status,
      'totalAmount': totalAmount,
      'items': items.map((item) => item.toJson()).toList(),
      'deliveryFee': deliveryFee,
      'paymentMethod': paymentMethod,
    };
  }

  String get formattedDate {
    return DateFormat('dd/MM/yyyy - HH:mm').format(date);
  }
} 