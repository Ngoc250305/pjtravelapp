import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pjtravelapp/entities/account.dart';
import 'package:pjtravelapp/entities/attraction.dart';
import 'package:pjtravelapp/entities/location.dart';
import 'package:pjtravelapp/entities/region.dart';
import 'package:pjtravelapp/entities/tour.dart';
import 'package:pjtravelapp/entities/dish.dart';
// import 'package:pjtravelapp/entities/Attraction.dart';

class ApiService {
  static const String baseUrl = "http://192.168.2.7.107:9999/api";

  // ==================== ACCOUNT ENDPOINTS ====================
  static Future<bool> register(Account account) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/register'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "username": account.username,
        "password": account.password,
        "email": account.email,
        "role": account.role,
      }),
    );
    return response.statusCode == 201;
  }

  static Future<bool> verifyOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/verify-otp'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "email": email,
        "otp": otp,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<Account?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/login'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "username": username,
        "password": password,
      }),
    );
    if (response.statusCode == 200) {
      return Account.fromJson(json.decode(response.body));
    }
    return null;
  }

  static Future<List<Account>> getAllAccounts() async {
    final response = await http.get(Uri.parse('$baseUrl/accounts'));
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

  // ==================== LOCATION ENDPOINTS ====================
  static Future<List<Location>> getLocations() async {
    final response = await http.get(Uri.parse('$baseUrl/locations'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Location> locationList = [];
      for (var l in data) {
        locationList.add(Location.fromJson(l));
      }
      return locationList;
    } else {
      throw Exception('Failed to load locations');
    }
  }

  static Future<Location?> getLocationById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/locations/$id'));
    if (response.statusCode == 200) {
      return Location.fromJson(json.decode(response.body));
    }
    return null;
  }

  // ==================== REGION ENDPOINTS ====================
  static Future<List<Region>> getRegions() async {
    final response = await http.get(Uri.parse('$baseUrl/regions'));
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


  static Future<List<Location>> getLocationsByRegion(int regionId) async {
    final response = await http.get(Uri.parse('$baseUrl/regions/$regionId/locations'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return List<Location>.from(data.map((x) => Location.fromJson(x)));
    } else {
      throw Exception('Failed to load region locations');
    }
  }

  // ==================== ATTRACTION ENDPOINTS ====================
  static Future<List<Attraction>> getAttractionsByLocation(int locationId) async {
    final response = await http.get(Uri.parse('$baseUrl/attractions/location/$locationId'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return List<Attraction>.from(data.map((x) => Attraction.fromJson(x)));
    } else {
      throw Exception('Failed to load attractions');
    }
  }

  // ==================== DISH ENDPOINTS ====================
  static Future<List<Dish>> getDishesByLocation(int locationId) async {
    final response = await http.get(Uri.parse('$baseUrl/dishes/location/$locationId'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return List<Dish>.from(data.map((x) => Dish.fromJson(x)));
    } else {
      throw Exception('Failed to load dishes');
    }
  }

  // ==================== TOUR ENDPOINTS ====================
  static Future<List<Tour>> getTours() async {
    final response = await http.get(Uri.parse('$baseUrl/tours'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return List<Tour>.from(data.map((x) => Tour.fromJson(x)));
    } else {
      throw Exception('Failed to load tours');
    }
  }

  static Future<Tour?> getFullTour(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/tours/$id/full'));
    if (response.statusCode == 200) {
      return Tour.fromJson(json.decode(response.body));
    }
    return null;
  }
}