// auth_service.dart
import 'package:pjtravelapp/entities/account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ApiService.dart';

class AuthService {
  static Account? currentAccount;
  static String? token;

  /// Kiểm tra trạng thái đăng nhập
  static bool get isLoggedIn => currentAccount != null && token != null;

  /// Load token và account từ SharedPreferences
  static Future<void> loadCurrentAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('auth_token');

      if (token != null) {
        // Gọi API để decode token và lấy thông tin account
        currentAccount = await ApiService.getAccountFromToken(token!);
      }
    } catch (e) {
      token = null;
      currentAccount = null;
      print('❌ Error loading current account: $e');
    }
  }

  /// Lưu token vào SharedPreferences và cập nhật account
  static Future<void> saveToken(String newToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', newToken);
      token = newToken;

      // Cập nhật account từ token mới
      currentAccount = await ApiService.getAccountFromToken(newToken);
    } catch (e) {
      print('❌ Error saving token: $e');
    }
  }

  /// Logout: xóa token và account
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      print('❌ Error removing token: $e');
    }
    token = null;
    currentAccount = null;
  }
}
