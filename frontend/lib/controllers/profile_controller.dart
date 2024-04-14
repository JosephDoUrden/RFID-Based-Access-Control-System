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
        Uri.parse('http://localhost:3000/api/profile'),
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
}
