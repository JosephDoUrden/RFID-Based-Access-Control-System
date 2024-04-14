import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/controllers/profile_controller.dart';
import 'package:frontend/views/dashboard/profile/change_password_view.dart';
import 'package:frontend/views/dashboard/profile/edit_profile_view.dart';
import 'package:frontend/views/login/login_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<Map<String, dynamic>> _profileDataFuture;

  @override
  void initState() {
    super.initState();
    _profileDataFuture = _fetchProfileData();
  }

  Future<Map<String, dynamic>> _fetchProfileData() async {
    try {
      return await ProfileController.fetchProfileData();
    } catch (error) {
      // Handle error
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _profileDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final profileData = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileItem(
                    label: 'Username',
                    value: profileData['username'],
                  ),
                  _buildProfileItem(
                    label: 'Full Name',
                    value: '${profileData['firstname']} ${profileData['lastname']}',
                  ),
                  _buildProfileItem(
                    label: 'Email',
                    value: profileData['email'],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfileView(
                                        username: profileData['username'],
                                        firstname: profileData['firstname'],
                                        lastname: profileData['lastname'],
                                        email: profileData['email'],
                                      )));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.blue[900],
                        ),
                        child: const Text('Edit Profile', style: TextStyle(fontSize: 16.0, color: Colors.white)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordView()));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.blue[900],
                        ),
                        child: const Text('Change Password', style: TextStyle(fontSize: 16.0, color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    widthFactor: 3.5,
                    child: ElevatedButton(
                      onPressed: () {
                        _showLogoutConfirmationDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Logout', style: TextStyle(fontSize: 16.0, color: Colors.white)),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileItem({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout action
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
