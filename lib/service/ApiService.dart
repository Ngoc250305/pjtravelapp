
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:pjtravelapp/entities/account.dart';
import '../entities/UserProfile.dart';
import '../entities/Location.dart';
import '../entities/Region.dart';
import '../entities/Dish.dart';
import '../entities/Tour.dart';
import '../pages/account/LoginResponse.dart';

class ApiService {
  static const String baseUrl = "http://192.168.2.7:9999/api";
  static const int timeoutSeconds = 10;

  static Map<String, String> _headers(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  // ==================== ACCOUNT ENDPOINTS ====================
  static Future<bool> register(Account account) async {
    final response = await _handleRequest(
      http.post(
        Uri.parse('$baseUrl/accounts/register'),
        headers: await _getHeaders(),
        body: json.encode({
          "username": account.username,
          "password": account.password,
          "email": account.email,
          "role": account.role,
        }),
      ),
    );
    return response.statusCode == 201;
  }

  static Future<bool> verifyOtp(String email, String otp) async {
    final response = await _handleRequest(
      http.post(
        Uri.parse('$baseUrl/accounts/verify-otp'),
        headers: await _getHeaders(),
        body: json.encode({
          "email": email,
          "otp": otp,
        }),
      ),
    );
    return response.statusCode == 200;
  }

  static Future<LoginResponse?> login(String username, String password) async {
    try {
      print('🔍 Trying to login with username: $username');
      final response = await _handleRequest(
        http.post(
          Uri.parse('$baseUrl/accounts/login'),
          headers: await _getHeaders(),
          body: json.encode({
            "username": username,
            "password": password,
          }),
        ),
      );

      print('✅ API Response: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['accountId'] == null) {
          print('❌ accountId is null in response.');
          return null;
        }

        return LoginResponse.fromJson(data);
      } else {
        print('❌ Login failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error during login: $e');
      return null;
    }
  }

  static Future<Account?> getAccountById(int accountId) async {
    try {
      final response = await _handleRequest(
        http.get(
          Uri.parse('$baseUrl/accounts/$accountId'),
          headers: await _getHeaders(),
        ),
      );

      print('✅ Get Account Detail: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return Account.fromJson(data);
      } else {
        print('❌ Failed to get account with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error getting account: $e');
      return null;
    }
  }

  static Future<List<Account>> getAllAccounts() async {
    final response = await _handleRequest(
      http.get(
        Uri.parse('$baseUrl/accounts'),
        headers: await _getHeaders(),
      ),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Account> accountList = [];
      for (var a in data) {
        accountList.add(Account.fromJson(a));
      }
      return accountList;
    } else {
      throw Exception('Failed to load accounts');
    }
  }

  // ==================== USER PROFILE ====================
  static Future<UserProfile> getUserProfile(int accountId) async {
    final response = await _handleRequest(
      http.get(
        Uri.parse('$baseUrl/profiles/$accountId'),
        headers: await _getHeaders(),
      ),
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  static Future<bool> createUserProfile(Map<String, dynamic> payload) async {
    final response = await _handleRequest(
      http.post(
        Uri.parse('$baseUrl/profiles'),
        headers: await _getHeaders(),
        body: json.encode(payload),
      ),
    );
    return response.statusCode == 201;
  }

  static Future<bool> updateUserProfile(int accountId, Map<String, dynamic> payload) async {
    final response = await _handleRequest(
      http.put(
        Uri.parse('$baseUrl/profiles/$accountId'),
        headers: await _getHeaders(),
        body: json.encode(payload),
      ),
    );
    return response.statusCode == 200;
  }

  static Future<String> uploadAvatar(File file) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/profiles/upload'));
    request.files.add(await http.MultipartFile.fromPath('file', file.path, filename: basename(file.path)));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      return jsonResponse['fileName'];
    } else {
      throw Exception('Failed to upload avatar');
    }
  }

  static Future<bool> deleteAvatar(String fileName) async {
    final response = await _handleRequest(
      http.delete(
        Uri.parse('$baseUrl/profiles/delete/$fileName'),
        headers: await _getHeaders(),
      ),
    );
    return response.statusCode == 200;
  }

  // ==================== OTP & RESET PASSWORD ====================
  static Future<void> sendOtp(String email) async {
    final response = await _handleRequest(
      http.post(
        Uri.parse('$baseUrl/accounts/send-otp?email=$email'),
        headers: await _getHeaders(),
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send OTP');
    }
  }

  static Future<void> resetPassword(String email, String otp, String newPassword) async {
    final response = await _handleRequest(
      http.post(
        Uri.parse('$baseUrl/accounts/reset-password'),
        headers: await _getHeaders(),
        body: json.encode({'email': email, 'otp': otp, 'newPassword': newPassword}),
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Reset password failed');
    }
  }

  // ==================== LOCATION ENDPOINTS ====================
  static Future<List<Location>> getLocations() async {
    final response = await _handleRequest(
      http.get(
        Uri.parse('$baseUrl/locations'),
        headers: await _getHeaders(),
      ),
    );

    final data = json.decode(response.body) as List;
    return data.map((json) => Location.fromJson(json)).toList();
  }

  static Future<Location?> getLocationById(int id) async {
    final response = await _handleRequest(
      http.get(
        Uri.parse('$baseUrl/locations/$id'),
        headers: await _getHeaders(),
      ),
    );

    if (response.statusCode == 200) {
      return Location.fromJson(json.decode(response.body));
    }
    return null;
  }

  static Future<List<Location>> getLocationsByRegion(int regionId) async {
    final response = await _handleRequest(
      http.get(
        Uri.parse('$baseUrl/regions/$regionId/locations'),
        headers: await _getHeaders(),
      ),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return List<Location>.from(data.map((x) => Location.fromJson(x)));
    } else {
      throw Exception('Failed to load region locations');
    }
  }

  // ==================== REGION ENDPOINTS ====================
  static Future<List<Region>> getRegions() async {
    final response = await _handleRequest(
      http.get(
        Uri.parse('$baseUrl/regions'),
        headers: await _getHeaders(),
      ),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Region> regionList = [];
      for (var r in data) {
        regionList.add(Region.fromJson(r));
      }
      return regionList;
    } else {
      throw Exception('Failed to load regions');
    }
  }

  // ==================== DISH ENDPOINTS ====================
  static Future<List<Dish>> getDishesByLocation(int locationId) async {
    final response = await _handleRequest(
      http.get(
        Uri.parse('$baseUrl/dishes/location/$locationId'),
        headers: await _getHeaders(),
      ),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return List<Dish>.from(data.map((x) => Dish.fromJson(x)));
    } else {
      throw Exception('Failed to load dishes');
    }
  }

// Trong ApiService
static Future<Account?> getAccountFromToken(String token) async {
  try {
    final url = Uri.parse('$baseUrl/accounts/decode-token'); // endpoint backend trả account từ token
    final response = await http.get(url, headers: _headers(token));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Account.fromJson(data);
    } else {
      print('❌ Failed to decode token: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('❌ Error decoding token: $e');
    return null;
  }
}

  // ==================== TOUR ENDPOINTS ====================
  static Future<List<Tour>> getTours() async {
    final response = await _handleRequest(
      http.get(
        Uri.parse('$baseUrl/tours'),
        headers: await _getHeaders(),
      ),
    );

    final data = json.decode(response.body) as List;
    return data.map((json) => Tour.fromJson(json)).toList();
  }

  static Future<Tour?> getFullTour(int id) async {
    final response = await _handleRequest(
      http.get(
        Uri.parse('$baseUrl/tours/$id/full'),
        headers: await _getHeaders(),
      ),
    );

    if (response.statusCode == 200) {
      return Tour.fromJson(json.decode(response.body));
    }
    return null;
  }

  // ==================== TEST CONNECTION ====================
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Connection test failed: $e');
      return false;
    }
  }

  // ==================== COMMON HELPERS ====================
  static Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  static Future<http.Response> _handleRequest(Future<http.Response> request) async {
    try {
      final response = await request.timeout(const Duration(seconds: timeoutSeconds));

      if (response.statusCode >= 400) {
        throw HttpException(
          'Request failed with status: ${response.statusCode}',
          uri: response.request?.url,
        );
      }

      if (kDebugMode) {
        debugPrint('API Response: ${response.body}');
      }

      return response;
    } on SocketException {
      throw const SocketException('No Internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timeout after ${timeoutSeconds}s');
    } catch (e) {
      debugPrint('API Error: $e');
      rethrow;
    }
  }
  static Future<List<Tour>> getToursByAccount(int accountId, String token) async {
    final url = Uri.parse('$baseUrl/tours/account/$accountId');
    final res = await http.get(url, headers: _headers(token));
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List<dynamic>;
      return list.map((e) => Tour.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to fetch tours');
  }
}
