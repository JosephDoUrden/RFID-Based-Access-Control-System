import 'package:flutter/material.dart';
import 'package:frontend/components/custom_password_field.dart';
import 'package:frontend/components/custom_text_field.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/views/login/login_view.dart';

class ResetPasswordView extends StatefulWidget {
  final String email; // Store the email from the forgot password screen

  const ResetPasswordView({Key? key, required this.email}) : super(key: key);

  @override
  _ResetPasswordViewState createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController _resetCodeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Reset Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30.0),
              CustomTextField(
                controller: _resetCodeController,
                label: 'Reset Code',
                icon: Icons.code,
              ),
              const SizedBox(height: 20.0),
              CustomPasswordField(
                controller: _newPasswordController,
                label: 'Password',
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: Text('Reset Password', style: TextStyle(fontSize: 18.0, color: Colors.blue[900])),
              ),
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 20.0),
                Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text("Back To Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetPassword() async {
    setState(() {
      _errorMessage = '';
    });

    // Get the email from the widget
    String email = widget.email;
    String resetCode = _resetCodeController.text;
    String newPassword = _newPasswordController.text;

    bool resetSuccessful = await AuthController.resetPassword(email, resetCode, newPassword);
    if (resetSuccessful) {
      // Show success alert
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Password Reset Successful'),
            content: Text('Your password has been reset successfully.'),
          );
        },
      );
      // Delay navigation to login screen
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      });
    } else {
      setState(() {
        _errorMessage = 'Failed to reset password. Please check your reset code and try again.';
      });
    }
  }
}
