import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase/supabase.dart';

class SupabaseService {
  static late final SupabaseClient _client;

  static Future<void> initialize() async {
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    _client = SupabaseClient(supabaseUrl, supabaseKey);
  }

  static SupabaseClient get client => _client;

  // المصادقة
  Future<AuthResponse> signUp(String email, String password) async {
    return await client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // التحقق من حالة المصادقة
  User? get currentUser => client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  // إدارة الملف الشخصي
  Future<void> createProfile(String userId, String name, String phone) async {
    await client.from('profiles').insert({
      'id': userId,
      'name': name,
      'phone': phone,
      'is_admin': false,
    });
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final response =
        await client.from('profiles').select().eq('id', userId).single();

    return response;
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    await client.from('profiles').update(data).eq('id', userId);
  }

  // إدارة المنتجات
  // Future<List<Map<String, dynamic>>> getProducts() async {
  //   final response = await client.from('products').select().order('created_at');

  //   return List<Map<String, dynamic>>.from(response);
  // }

  Future<Map<String, dynamic>> getProduct(String id) async {
    final response =
        await client.from('products').select().eq('id', id).single();

    return response;
  }

  Future<void> addProduct(Map<String, dynamic> product) async {
    await client.from('products').insert(product);
  }

  Future<void> updateProduct(String id, Map<String, dynamic> product) async {
    await client.from('products').update(product).eq('id', id);
  }

  Future<void> deleteProduct(String id) async {
    await client.from('products').delete().eq('id', id);
  }

  // إدارة سلة التسوق
  Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    final response = await client
        .from('cart_items')
        .select('*, products(*)')
        .eq('user_id', userId);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addToCart(String userId, String productId, int quantity) async {
    // التحقق مما إذا كان المنتج موجوداً بالفعل في السلة
    final existing =
        await client
            .from('cart_items')
            .select()
            .eq('user_id', userId)
            .eq('product_id', productId)
            .maybeSingle();

    if (existing != null) {
      // تحديث الكمية
      await client
          .from('cart_items')
          .update({'quantity': existing['quantity'] + quantity})
          .eq('id', existing['id']);
    } else {
      // إضافة عنصر جديد
      await client.from('cart_items').insert({
        'user_id': userId,
        'product_id': productId,
        'quantity': quantity,
      });
    }
  }

  Future<void> updateCartItemQuantity(String itemId, int quantity) async {
    await client
        .from('cart_items')
        .update({'quantity': quantity})
        .eq('id', itemId);
  }

  Future<void> removeFromCart(String itemId) async {
    await client.from('cart_items').delete().eq('id', itemId);
  }

  Future<void> clearCart(String userId) async {
    await client.from('cart_items').delete().eq('user_id', userId);
  }

  // إدارة الطلبات
  Future<String> createOrder(
    String userId,
    double totalAmount,
    String address,
    String paymentMethod,
  ) async {
    // إنشاء الطلب
    final orderResponse =
        await client
            .from('orders')
            .insert({
              'user_id': userId,
              'total_amount': totalAmount,
              'status': 'pending',
              'shipping_address': address,
              'payment_method': paymentMethod,
              'payment_status': 'pending',
            })
            .select('id')
            .single();

    final orderId = orderResponse['id'];

    // الحصول على عناصر السلة
    final cartItems = await getCartItems(userId);

    // إضافة عناصر الطلب
    for (var item in cartItems) {
      await client.from('order_items').insert({
        'order_id': orderId,
        'product_id': item['product_id'],
        'quantity': item['quantity'],
        'price': item['products']['price'],
      });
    }

    // مسح السلة
    await clearCart(userId);

    return orderId;
  }

  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    final response = await client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> getOrder(String orderId) async {
    final response =
        await client.from('orders').select().eq('id', orderId).single();

    return response;
  }

  Future<List<Map<String, dynamic>>> getOrderItems(String orderId) async {
    final response = await client
        .from('order_items')
        .select('*, products(*)')
        .eq('order_id', orderId);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await client.from('orders').update({'status': status}).eq('id', orderId);
  }

  Future<void> updatePaymentStatus(String orderId, String status) async {
    await client
        .from('orders')
        .update({'payment_status': status})
        .eq('id', orderId);
  }

  // للمسؤولين
  Future<List<Map<String, dynamic>>> getAllOrders() async {
    final response = await client
        .from('orders')
        .select('*, profiles(*)')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<bool> isAdmin(String userId) async {
    final profile = await getProfile(userId);
    return profile != null && profile['is_admin'] == true;
  }

  // // الحصول على جميع المنتجات
  // Future<List<Map<String, dynamic>>> getProducts() async {
  //   final response = await client.from('products').select().order('created_at');

  //   return List<Map<String, dynamic>>.from(response);
  // }

  // Get all products
  Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await client.from('products').select().order('created_at');

    if (response is List) {
      return response.cast<Map<String, dynamic>>();
    }

    return [];
  }

  // // الحصول على المنتجات حسب الفئة
  // Future<List<Map<String, dynamic>>> getProductsByCategory(
  //   String category,
  // ) async {
  //   final response = await client
  //       .from('products')
  //       .select()
  //       .eq('category', category)
  //       .order('created_at');

  //   return List<Map<String, dynamic>>.from(response);
  // }

  // Get products by category
  Future<List<Map<String, dynamic>>> getProductsByCategory(
    String category,
  ) async {
    final response = await client
        .from('products')
        .select()
        .eq('category', category)
        .order('created_at');

    if (response is List) {
      return response.cast<Map<String, dynamic>>();
    }

    return [];
  }

  // // الحصول على المنتجات المميزة
  // Future<List<Map<String, dynamic>>> getFeaturedProducts() async {
  //   final response = await client
  //       .from('products')
  //       .select()
  //       .eq('is_featured', true)
  //       .order('created_at');

  //   return List<Map<String, dynamic>>.from(response);
  // }

  // Get featured products
  Future<List<Map<String, dynamic>>> getFeaturedProducts() async {
    final response = await client
        .from('products')
        .select()
        .eq('is_featured', true)
        .order('created_at');

    if (response is List) {
      return response.cast<Map<String, dynamic>>();
    }

    return [];
  }

  // // البحث عن المنتجات
  // Future<List<Map<String, dynamic>>> searchProducts(String query) async {
  //   final response = await client
  //       .from('products')
  //       .select()
  //       .ilike('title', '%$query%')
  //       .order('created_at');

  //   return List<Map<String, dynamic>>.from(response);
  // }
  
  // Search products
Future<List<Map<String, dynamic>>> searchProducts(String query) async {
  final response = await client
      .from('products')
      .select()
      .ilike('title', '%$query%')
      .order('created_at');
  
  if (response is List) {
    return response.cast<Map<String, dynamic>>();
  }
  
  return [];
}
}
