class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.isAdmin = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      isAdmin: json['is_admin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'is_admin': isAdmin,
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    bool? isAdmin,
  }) {
    return UserModel(
      id: id,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
