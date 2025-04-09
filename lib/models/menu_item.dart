class MenuItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool featured;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.featured,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      featured: json['featured'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'featured': featured,
    };
  }
}

class MenuCategory {
  final String name;
  final List<MenuItem> items;

  MenuCategory({
    required this.name,
    required this.items,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      name: json['name'],
      items: (json['items'] as List<dynamic>)
          .map((item) => MenuItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class RestaurantMenu {
  final int restaurantId;
  final List<MenuCategory> categories;

  RestaurantMenu({
    required this.restaurantId,
    required this.categories,
  });

  factory RestaurantMenu.fromJson(Map<String, dynamic> json) {
    return RestaurantMenu(
      restaurantId: json['restaurantId'],
      categories: (json['categories'] as List<dynamic>)
          .map((category) => MenuCategory.fromJson(category))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }
} 