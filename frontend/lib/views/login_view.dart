import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/views/dashboard_view.dart';
import 'package:frontend/views/register_view.dart'; // Import the RegisterView

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isObscure = true; // Initially, the password is obscured

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900], // Navy blue background color
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white), // Text color
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)), // Hint text color
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person, color: Colors.white), // Icon color
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white), // Text color
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)), // Hint text color
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white), // Icon color
                  suffixIcon: IconButton(
                    icon: _isObscure
                        ? const Icon(Icons.visibility_off, color: Colors.white)
                        : const Icon(Icons.visibility, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure; // Toggle the password visibility
                      });
                    },
                  ),
                ),
                obscureText: _isObscure, // Toggle the obscure text based on state
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  bool loggedIn = await AuthController.login(_usernameController.text, _passwordController.text);
                  if (loggedIn) {
                    // Navigate to dashboard upon successful login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardView()),
                    );
                  } else {
                    // Show error message
                    setState(() {
                      _errorMessage = 'Login failed. Please check your credentials.';
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue[900], backgroundColor: Colors.white, // Button text color
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              if (_errorMessage.isNotEmpty) const SizedBox(height: 20.0),
              Text(
                _errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  // Navigate to the registration page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterView()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // Button text color
                ),
                child: const Text(
                  "Don't you have an account? Register here",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
