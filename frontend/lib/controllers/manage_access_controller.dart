import 'dart:convert';
import 'package:frontend/models/permission.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ManageAccessController {
  static const String _baseUrl = 'http://195.35.28.226:3000/api/dashboard';

  Future<List<Permission>> fetchPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/permissions'),
      headers: <String, String>{
        'Authorization': token,
      },
    );

    // Log response details for debugging
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Permission.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else {
      throw Exception('Failed to load permissions');
    }
  }

  Future<void> updatePermission(int permissionID, String newPermission) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/update-permission'),
      headers: <String, String>{
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'permissionID': permissionID,
        'newPermission': newPermission,
      }),
    );

    // Log response details for debugging
    //print('Update response status: ${response.statusCode}');
    //print('Update response body: ${response.body}');

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      } else {
        throw Exception('Failed to update permission');
      }
    }
  }
}
