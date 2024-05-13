import 'dart:convert';

import 'package:frontend/models/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController {
  static Future<UserProfile> fetchDashboardData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/dashboard'),
        headers: <String, String>{
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        return UserProfile.fromJson(jsonData);
      } else {
        throw Exception('Failed to load dashboard data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching dashboard data: $error');
    }
  }

  static Future<String> fetchLogsData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/dashboard/logs'),
        headers: <String, String>{
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load logs data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching logs data: $error');
    }
  }
}
