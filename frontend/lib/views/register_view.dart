import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/views/login_view.dart';
import 'package:frontend/components/custom_text_field.dart';
import 'package:frontend/components/custom_button.dart';
import 'package:frontend/components/error_message.dart';

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
                'Register',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color
                ),
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                controller: _usernameController,
                hintText: 'Username',
                textColor: Colors.white,
                hintColor: Colors.white.withOpacity(0.6),
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                controller: _firstnameController,
                hintText: 'First Name',
                textColor: Colors.white,
                hintColor: Colors.white.withOpacity(0.6),
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                controller: _lastnameController,
                hintText: 'Last Name',
                textColor: Colors.white,
                hintColor: Colors.white.withOpacity(0.6),
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
                textColor: Colors.white,
                hintColor: Colors.white.withOpacity(0.6),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white), // Text color
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)), // Hint text color
                  border: const OutlineInputBorder(),
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
              CustomButton(
                onPressed: _register,
                text: 'Register', // Change from buttonText to text
                textColor: Colors.blue[900]!,
                buttonColor: Colors.white, // Change backgroundColor to buttonColor
              ),
              if (_errorMessage.isNotEmpty) const SizedBox(height: 20.0),
              ErrorMessage(message: _errorMessage, color: Colors.red),
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

  void _register() async {
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
        _errorMessage = AuthController.errorMessage ?? 'Registration failed. Please try again.';
      });
    }
  }
}
