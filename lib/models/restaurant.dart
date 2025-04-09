class Restaurant {
  final int id;
  final String name;
  final String logoUrl;
  final String coverUrl;
  final double rating;
  final String category;
  final String deliveryTime;
  final double deliveryFee;
  final double minimumOrder;
  final double distance;
  final bool featured;
  final String address;
  final String description;

  Restaurant({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.coverUrl,
    required this.rating,
    required this.category,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.distance,
    required this.featured,
    required this.address,
    required this.description,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logoUrl'],
      coverUrl: json['coverUrl'],
      rating: json['rating'].toDouble(),
      category: json['category'],
      deliveryTime: json['deliveryTime'],
      deliveryFee: json['deliveryFee'].toDouble(),
      minimumOrder: json['minimumOrder'].toDouble(),
      distance: json['distance'].toDouble(),
      featured: json['featured'],
      address: json['address'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'coverUrl': coverUrl,
      'rating': rating,
      'category': category,
      'deliveryTime': deliveryTime,
      'deliveryFee': deliveryFee,
      'minimumOrder': minimumOrder,
      'distance': distance,
      'featured': featured,
      'address': address,
      'description': description,
    };
  }
} 