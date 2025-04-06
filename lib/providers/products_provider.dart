// lib/providers/products_provider.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/supabase_service.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _error;

  final SupabaseService _supabaseService = SupabaseService();

  List<Product> get items => [..._items];
  List<String> get categories => [..._categories];
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get featured products
  List<Product> get featuredProducts {
    return _items.where((product) => product.isFeatured).toList();
  }

  // Get products by category
  List<Product> getProductsByCategory(String category) {
    return _items.where((product) => product.category == category).toList();
  }

  // Search products
  List<Product> searchProducts(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _items.where((product) {
      return product.title.toLowerCase().contains(lowercaseQuery) ||
          product.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Filter products by price
  List<Product> filterProductsByPrice(double minPrice, double maxPrice) {
    return _items.where((product) {
      return product.price >= minPrice && product.price <= maxPrice;
    }).toList();
  }

  // Get product by id
  Product findById(String id) {
    return _items.firstWhere(
      (product) => product.id == id,
      orElse: () => throw Exception('Product not found'),
    );
  }

  // Fetch all products from Supabase
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print("Fetching products from Supabase...");
      final productsData = await _supabaseService.getProducts();
      print("Products data received: ${productsData.length} items");

      _items = productsData.map((data) => Product.fromJson(data)).toList();
      print("Products converted to model: ${_items.length} items");

      // Extract unique categories
      final Set<String> uniqueCategories = {};
      for (var product in _items) {
        uniqueCategories.add(product.category);
      }
      _categories = uniqueCategories.toList()..sort();
      print("Categories extracted: ${_categories.length} categories");

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching products: $e");
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch products by category from Supabase
  Future<void> fetchProductsByCategory(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final productsData = await _supabaseService.getProductsByCategory(
        category,
      );

      _items = productsData.map((data) => Product.fromJson(data)).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch featured products from Supabase
  Future<void> fetchFeaturedProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final productsData = await _supabaseService.getFeaturedProducts();

      _items = productsData.map((data) => Product.fromJson(data)).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
