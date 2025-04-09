class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? photoUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'photoUrl': photoUrl,
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? photoUrl,
  }) {
    return User(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
} 