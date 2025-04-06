import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/supabase_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;

  final SupabaseService _supabaseService = SupabaseService();

  AuthProvider() {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
  final currentUser = _supabaseService.currentUser;
  if (currentUser != null) {
    try {
      final profile = await _supabaseService.getProfile(currentUser.id);
      if (profile != null) {
        _user = UserModel(
          id: currentUser.id,
          email: currentUser.email!,
          name: profile['name'],
          phone: profile['phone'],
          isAdmin: profile['is_admin'] ?? false,
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error initializing user: $e');
    }
  } else {
    // محاولة تسجيل الدخول التلقائي إذا كان المستخدم الحالي غير موجود
    await tryAutoLogin();
  }
}


  Future<bool> signUp(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _supabaseService.signUp(email, password);

      if (response.user != null) {
        await _supabaseService.createProfile(response.user!.id, name, phone);

        _user = UserModel(
          id: response.user!.id,
          email: email,
          name: name,
          phone: phone,
          isAdmin: false,
        );

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'فشل في إنشاء الحساب';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // تعديل توقيع الدالة لتقبل معلمة rememberMe اختيارية
  Future<bool> signIn(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _supabaseService.signIn(email, password);

      if (response.user != null) {
        final profile = await _supabaseService.getProfile(response.user!.id);

        if (profile != null) {
          _user = UserModel(
            id: response.user!.id,
            email: email,
            name: profile['name'],
            phone: profile['phone'],
            isAdmin: profile['is_admin'] ?? false,
          );
        } else {
          _user = UserModel(id: response.user!.id, email: email);
        }

        // حفظ حالة "تذكرني" إذا كانت مفعلة
        if (rememberMe) {
          // يمكنك استخدام shared_preferences لحفظ حالة تسجيل الدخول
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('remembered_user_id', _user!.id);
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'فشل في تسجيل الدخول';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _supabaseService.signOut();
      _user = null;

      // مسح المستخدم المحفوظ
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('remembered_user_id');
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(String name, String phone) async {
    if (_user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _supabaseService.updateProfile(_user!.id, {
        'name': name,
        'phone': phone,
      });

      _user = _user!.copyWith(name: name, phone: phone);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // أضف هذه الدالة في class AuthProvider
  Future<void> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('remembered_user_id');

      if (userId != null) {
        final currentUser = _supabaseService.currentUser;
        if (currentUser != null && currentUser.id == userId) {
          final profile = await _supabaseService.getProfile(userId);
          if (profile != null) {
            _user = UserModel(
              id: userId,
              email: currentUser.email!,
              name: profile['name'],
              phone: profile['phone'],
              isAdmin: profile['is_admin'] ?? false,
            );
            notifyListeners();
          }
        } else {
          // إذا كان المستخدم غير مصادق عليه، قم بمسح المعرف المحفوظ
          await prefs.remove('remembered_user_id');
        }
      }
    } catch (e) {
      print('Error in auto login: $e');
    }
  }
}
