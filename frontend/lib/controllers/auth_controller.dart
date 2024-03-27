import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
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
      return true; // Kayıt başarılı ise true döner
    } else {
      return false; // Kayıt başarısız ise false döner
    }
  }

  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Parse the response body
      Map<String, dynamic> data = jsonDecode(response.body);
      // Extract token from the response
      String? token = data['token'];

      if (token != null) {
        // Store the token using shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return true; // Giriş başarılı ise true döner
      } else {
        return false; // Token alınamadıysa giriş başarısız olarak işaretlenir
      }
    } else {
      return false; // Giriş başarısız ise false döner
    }
  }
}
