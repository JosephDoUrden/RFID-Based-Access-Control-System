import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static String? errorMessage;

  static Future<bool> register(
    String username,
    String firstname,
    String lastname,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://195.35.28.226:3000/api/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'name': firstname,
          'surname': lastname,
          'email': email,
          'password': password,
        }),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        errorMessage = null;
        return true;
      } else {
        // Handle different error scenarios
        errorMessage = _parseErrorMessage(response.body);
        return false;
      }
    } catch (e) {
      errorMessage = 'Error: $e';
      return false;
    }
  }

  static String _parseErrorMessage(String responseBody) {
    // You may need to adjust this logic based on the actual response format
    if (responseBody.toLowerCase().contains('username')) {
      return 'Username already taken.';
    } else if (responseBody.toLowerCase().contains('email')) {
      return 'Email already registered.';
    } else {
      return 'Registration failed. Please try again.';
    }
  }

  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://195.35.28.226:3000/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      String? token = data['token'];

      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> sendResetCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://195.35.28.226:3000/api/auth/forgot-password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // Handle other status codes
        return false;
      }
    } catch (e) {
      // Handle exceptions
      print('Exception occurred while sending reset code: $e');
      return false;
    }
  }

  static Future<bool> resetPassword(String email, String resetCode, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('http://195.35.28.226:3000/api/auth/reset-password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'resetCode': resetCode,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // Handle other status codes
        return false;
      }
    } catch (e) {
      // Handle exceptions
      print('Exception occurred while resetting password: $e');
      return false;
    }
  }
}
