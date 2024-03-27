import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  String _dashboardData = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      // Retrieve the JWT token from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      // Make a GET request to the dashboard endpoint with the token included in the headers
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/dashboard'),
        headers: <String, String>{
          'Authorization': token,
        },
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        setState(() {
          _dashboardData = response.body;
        });
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: _errorMessage.isNotEmpty
            ? Text(_errorMessage)
            : _dashboardData.isNotEmpty
                ? Text(_dashboardData)
                : const CircularProgressIndicator(),
      ),
    );
  }
}
