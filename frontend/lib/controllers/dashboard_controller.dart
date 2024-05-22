import 'dart:convert';

import 'package:frontend/models/log.dart';
import 'package:frontend/models/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController {
  static Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not found');
    }
    return token;
  }

  static Future<UserProfile> fetchDashboardData() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('http://195.35.28.226:3000/api/dashboard'),
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

  static Future<List<Log>> fetchLogsData() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('http://195.35.28.226:3000/api/dashboard/logs'),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        // Parse the list of logs
        List<Log> logs = jsonData.map((log) => Log.fromJson(log)).toList();
        return logs;
      } else {
        throw Exception('Failed to load logs data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching logs data: $error');
    }
  }
}
