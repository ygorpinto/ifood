import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/order.dart';

class OrderRepository {
  Future<List<Order>> getOrders() async {
    try {
      final String response = await rootBundle.loadString('lib/data/mocks/json/user_orders.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar pedidos: $e');
    }
  }

  Future<Order?> getOrderById(int id) async {
    try {
      final orders = await getOrders();
      return orders.firstWhere((order) => order.id == id);
    } catch (e) {
      throw Exception('Pedido não encontrado: $e');
    }
  }

  // Em um app real, teríamos métodos para enviar pedidos para a API
  Future<Order> createOrder(Order order) async {
    // Simula a criação de um pedido com geração de ID
    return order;
  }
} 