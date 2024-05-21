import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController {
  static Future<Map<String, dynamic>> fetchProfileData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('http://195.35.28.226:3000/api/profile'),
        headers: <String, String>{
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  static Future<void> updateProfile(Map<String, dynamic> profileData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.put(
        Uri.parse('http://195.35.28.226:3000/api/profile'),
        headers: <String, String>{
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': profileData['Username'],
          'name': profileData['Name'],
          'surname': profileData['Surname'],
          'email': profileData['Email'],
        }),
      );

      if (response.statusCode == 200) {
        // Profile updated successfully
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  static Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.put(
        Uri.parse('http://195.35.28.226:3000/api/profile/change-password'),
        headers: <String, String>{
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Password changed successfully
      } else {
        throw Exception('Failed to change password');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  static Future<void> reportIssue(String subject, String issue) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.post(
        Uri.parse('http://195.35.28.226:3000/api/profile/report-issue'),
        headers: <String, String>{
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'subject': subject,
          'issue': issue,
        }),
      );

      if (response.statusCode == 200) {
        // Password changed successfully
      } else {
        throw Exception('Failed to change password');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
