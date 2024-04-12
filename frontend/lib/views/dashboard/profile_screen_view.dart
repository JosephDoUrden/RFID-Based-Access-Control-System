import 'package:flutter/material.dart';
import 'package:frontend/controllers/profile_controller.dart';

class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({Key? key}) : super(key: key);

  @override
  _ProfileScreenViewState createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  String _profileData = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      String profileData = await ProfileController.fetchProfileData();
      setState(() {
        _profileData = profileData;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: _errorMessage.isNotEmpty
                ? Text(_errorMessage)
                : _profileData.isNotEmpty
                    ? Text(_profileData)
                    : const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
