import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/views/login/login_view.dart';

class ResetPasswordScreenView extends StatefulWidget {
  final String email; // Store the email from the forgot password screen

  const ResetPasswordScreenView({Key? key, required this.email}) : super(key: key);

  @override
  _ResetPasswordScreenViewState createState() => _ResetPasswordScreenViewState();
}

class _ResetPasswordScreenViewState extends State<ResetPasswordScreenView> {
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
              TextFormField(
                controller: _resetCodeController,
                decoration: InputDecoration(
                  labelText: 'Reset Code',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.code, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                cursorColor: Colors.white,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                cursorColor: Colors.white,
                obscureText: true,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
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
