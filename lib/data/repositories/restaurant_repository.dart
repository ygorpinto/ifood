import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/restaurant.dart';
import '../../models/menu_item.dart';
import '../../models/category.dart';

class RestaurantRepository {
  Future<List<Restaurant>> getRestaurants() async {
    try {
      final String response = await rootBundle.loadString('lib/data/mocks/json/restaurants.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Restaurant.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar restaurantes: $e');
    }
  }

  Future<Restaurant?> getRestaurantById(int id) async {
    try {
      final restaurants = await getRestaurants();
      return restaurants.firstWhere((restaurant) => restaurant.id == id);
    } catch (e) {
      throw Exception('Restaurante não encontrado: $e');
    }
  }

  Future<List<Restaurant>> getRestaurantsByCategory(String category) async {
    try {
      final restaurants = await getRestaurants();
      return restaurants.where((restaurant) => restaurant.category == category).toList();
    } catch (e) {
      throw Exception('Erro ao carregar restaurantes por categoria: $e');
    }
  }

  Future<List<Restaurant>> getFeaturedRestaurants() async {
    try {
      final restaurants = await getRestaurants();
      return restaurants.where((restaurant) => restaurant.featured).toList();
    } catch (e) {
      throw Exception('Erro ao carregar restaurantes em destaque: $e');
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final String response = await rootBundle.loadString('lib/data/mocks/json/categories.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar categorias: $e');
    }
  }

  Future<RestaurantMenu> getRestaurantMenu(int restaurantId) async {
    try {
      final String response = await rootBundle.loadString('lib/data/mocks/json/menu_items.json');
      final List<dynamic> data = json.decode(response);
      final restaurantMenuJson = data.firstWhere(
        (menu) => menu['restaurantId'] == restaurantId,
        orElse: () => throw Exception('Menu do restaurante não encontrado'),
      );
      return RestaurantMenu.fromJson(restaurantMenuJson);
    } catch (e) {
      throw Exception('Erro ao carregar o menu do restaurante: $e');
    }
  }
} 