import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/views/login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isPasswordObscured = true;

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
                'Register',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color
                ),
              ),
              const SizedBox(height: 20.0),
              _buildTextField(_usernameController, 'Username'),
              const SizedBox(height: 20.0),
              _buildTextField(_firstnameController, 'First Name'),
              const SizedBox(height: 20.0),
              _buildTextField(_lastnameController, 'Last Name'),
              const SizedBox(height: 20.0),
              _buildTextField(_emailController, 'Email'),
              const SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: _isPasswordObscured,
                style: const TextStyle(color: Colors.white), // Text color
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)), // Hint text color
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                    icon: Icon(
                      _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white, // Icon color
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _errorMessage = '';
                  });

                  if (_usernameController.text.isEmpty ||
                      _firstnameController.text.isEmpty ||
                      _lastnameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    setState(() {
                      _errorMessage = 'All fields are required.';
                    });
                    return;
                  }

                  bool registered = await AuthController.register(
                    _usernameController.text,
                    _firstnameController.text,
                    _lastnameController.text,
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (registered) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginView()),
                    );
                  } else {
                    setState(() {
                      _errorMessage = 'Registration failed. Please try again.';
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue[900], backgroundColor: Colors.white, // Button text color
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                ),
                child: const Text(
                  'Register',
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // Button text color
                ),
                child: const Text(
                  "Already have an account? Login here",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white), // Text color
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)), // Hint text color
        border: const OutlineInputBorder(),
      ),
    );
  }
}
