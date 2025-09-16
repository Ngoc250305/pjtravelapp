import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProfileService {
  static const String baseUrl = "http://192.168.2.7:9999/api/profiles";

  // ========== GET PROFILE ==========
  static Future<Map<String, dynamic>> getUserProfile(
      String accountId, String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$accountId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load profile: ${response.body}");
    }
  }

  // ========== CREATE PROFILE ==========
  static Future<Map<String, dynamic>> createUserProfile(
      Map<String, dynamic> profile, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(profile),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create profile: ${response.body}");
    }
  }

  // ========== UPDATE PROFILE ==========
  static Future<Map<String, dynamic>> updateUserProfile(
      String profileId, Map<String, dynamic> updatedProfile, String token) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$profileId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(updatedProfile),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to update profile: ${response.body}");
    }
  }

  // ========== DELETE PROFILE ==========
  static Future<void> deleteUserProfile(String accountId, String token) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$accountId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Failed to delete profile: ${response.body}");
    }
  }

  // ========== UPLOAD AVATAR ==========
  static Future<Map<String, dynamic>> uploadAvatar(
      String filePath, String token) async {
    var request =
        http.MultipartRequest("POST", Uri.parse("$baseUrl/upload"));

    request.headers["Authorization"] = "Bearer $token";
    request.files.add(await http.MultipartFile.fromPath("file", filePath));

    var response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr);
    } else {
      throw Exception("Failed to upload avatar");
    }
  }

  // ========== DELETE AVATAR ==========
  static Future<void> deleteAvatar(String fileName, String token) async {
    final response = await http.delete(
      Uri.parse("http://localhost:9999/api/avatar/$fileName"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Failed to delete avatar: ${response.body}");
    }
  }
}
