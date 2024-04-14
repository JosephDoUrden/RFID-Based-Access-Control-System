import 'package:flutter/material.dart';
import 'package:frontend/components/custom_text_field.dart';
import 'package:frontend/controllers/profile_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({
    Key? key,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.email,
  }) : super(key: key);

  final String username;
  final String firstname;
  final String lastname;
  final String email;

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.username;
    _firstNameController.text = widget.firstname;
    _lastNameController.text = widget.lastname;
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.blue[900],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(controller: _usernameController, label: 'Username', icon: Icons.person),
            const SizedBox(height: 10),
            CustomTextField(controller: _firstNameController, label: 'First Name', icon: Icons.person),
            const SizedBox(height: 10),
            CustomTextField(controller: _lastNameController, label: 'Last Name', icon: Icons.person),
            const SizedBox(height: 10),
            CustomTextField(controller: _emailController, label: 'Email', icon: Icons.email),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.white,
              ),
              child: Text('Update Profile', style: TextStyle(fontSize: 18.0, color: Colors.blue[900])),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    try {
      final Map<String, dynamic> profileData = {
        'username': _usernameController.text,
        'firstname': _firstNameController.text,
        'lastname': _lastNameController.text,
        'email': _emailController.text,
      };

      await ProfileController.updateProfile(profileData);

      // Profile updated successfully, navigate back or show success message
      Navigator.pop(context);
    } catch (error) {
      // Handle error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to update profile: $error'),
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
