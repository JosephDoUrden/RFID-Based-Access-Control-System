import 'package:flutter/material.dart';
import 'package:frontend/components/custom_password_field.dart';
import 'package:frontend/controllers/profile_controller.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Change Password', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.blue[900],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomPasswordField(controller: _oldPasswordController, label: 'Old Password'),
            const SizedBox(height: 10),
            CustomPasswordField(controller: _newPasswordController, label: 'New Password'),
            const SizedBox(height: 10),
            CustomPasswordField(controller: _confirmPasswordController, label: 'Confirm New Password'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.white,
              ),
              child: Text('Change Password', style: TextStyle(fontSize: 18.0, color: Colors.blue[900])),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changePassword() async {
    try {
      final String oldPassword = _oldPasswordController.text;
      final String newPassword = _newPasswordController.text;
      final String confirmPassword = _confirmPasswordController.text;

      if (newPassword != confirmPassword) {
        throw Exception('New password and confirm password do not match');
      }

      await ProfileController.changePassword(oldPassword, newPassword);

      // Password changed successfully, navigate back or show success message
      Navigator.pop(context);
    } catch (error) {
      // Handle error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to change password: $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
