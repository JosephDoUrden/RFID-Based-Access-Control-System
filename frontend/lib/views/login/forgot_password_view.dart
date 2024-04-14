import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/views/login/login_view.dart';
import 'package:frontend/views/login/reset_password_view.dart';

class ForgotPasswordScreenView extends StatefulWidget {
  const ForgotPasswordScreenView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenViewState createState() => _ForgotPasswordScreenViewState();
}

class _ForgotPasswordScreenViewState extends State<ForgotPasswordScreenView> {
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Forgot Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.email, color: Colors.white),
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
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.white,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _sendResetCode,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: Text('Send Reset Code', style: TextStyle(fontSize: 18.0, color: Colors.blue[900])),
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

  void _sendResetCode() async {
    setState(() {
      _errorMessage = '';
    });

    bool codeSent = await AuthController.sendResetCode(_emailController.text);
    if (codeSent) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreenView(email: _emailController.text),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Failed to send reset code. Please check your email address.';
      });
    }
  }
}
