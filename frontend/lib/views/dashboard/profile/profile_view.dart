import 'package:flutter/material.dart';
import 'package:frontend/controllers/profile_controller.dart';
import 'package:frontend/views/dashboard/profile/change_password_view.dart';
import 'package:frontend/views/dashboard/profile/edit_profile_view.dart';
import 'package:frontend/views/dashboard/profile/manage_access_view.dart';
import 'package:frontend/views/dashboard/profile/report_issue_view.dart';
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
      // Handle error gracefully
      return {'error': 'Failed to fetch profile data'};
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
            } else if (snapshot.hasError || snapshot.data!['error'] != null) {
              return Center(child: Text('Error: ${snapshot.data!['error'] ?? snapshot.error}'));
            } else {
              final profileData = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage('https://picsum.photos/id/1/200/300'),
                            ),
                            const SizedBox(height: 16),
                            _buildProfileItem(
                              label: 'Username',
                              value: profileData['Username'] ?? '',
                            ),
                            _buildProfileItem(
                              label: 'Full Name',
                              value: '${profileData['Name']} ${profileData['Surname']}',
                            ),
                            _buildProfileItem(
                              label: 'Email',
                              value: profileData['Email'] ?? '',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildButtonRow(
                      context: context,
                      buttons: [
                        _buildButton(
                          context: context,
                          label: 'Edit Profile',
                          icon: Icons.edit,
                          color: Colors.blue[900] ?? Colors.blue,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileView(
                                  username: profileData['Username'] ?? '',
                                  firstname: profileData['Name'] ?? '',
                                  lastname: profileData['Surname'] ?? '',
                                  email: profileData['Email'] ?? '',
                                ),
                              ),
                            );
                          },
                        ),
                        _buildButton(
                          context: context,
                          label: 'Change Password',
                          icon: Icons.lock,
                          color: Colors.blue[900] ?? Colors.blue,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ChangePasswordView()),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildButtonColumn(
                      context: context,
                      buttons: [
                        _buildButton(
                          context: context,
                          label: 'Report an Issue',
                          icon: Icons.report,
                          color: Colors.black38,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ReportIssueView()),
                            );
                          },
                        ),
                        if (profileData['RoleID'] == 1)
                          _buildButton(
                            context: context,
                            label: 'Manage Access',
                            icon: Icons.admin_panel_settings,
                            color: Colors.green,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ManageAccessView()),
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0.2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.red,
            ),
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow({required BuildContext context, required List<Widget> buttons}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }

  Widget _buildButtonColumn({required BuildContext context, required List<Widget> buttons}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buttons
          .map((button) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: button,
              ))
          .toList(),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: color,
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 16.0, color: Colors.white)),
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
