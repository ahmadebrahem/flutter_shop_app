// lib/models/product.dart
class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isFeatured;
  final double rating;
  final int reviewCount;
  final int stockQuantity;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isFeatured = false,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stockQuantity = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      imageUrl: json['image_url'],
      category: json['category'],
      // isFeatured: json['is_featured'] ?? false,
      isFeatured: json['is_featured'] == true,
      rating: double.parse((json['rating'] ?? 0.0).toString()),
      reviewCount: json['review_count'] ?? 0,
      stockQuantity: json['stock_quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category': category,
      'is_featured': isFeatured,
      'rating': rating,
      'review_count': reviewCount,
      'stock_quantity': stockQuantity,
    };
  }
}
