import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static String? errorMessage;

  static Future<bool> register(
      String username, String firstname, String lastname, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      errorMessage = null;
      return true;
    } else {
      switch (response.body) {
        case "Username already taken":
          errorMessage = 'Username already taken.';
          break;
        case "Email already registered":
          errorMessage = 'Email already registered.';
          break;
        default:
          errorMessage = 'Registration failed. Please try again.';
      }
      return false;
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
      return false;
    }
  }

  static Future<bool> resetPassword(String email, String resetCode, String newPassword) async {
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
      return false;
    }
  }
}
