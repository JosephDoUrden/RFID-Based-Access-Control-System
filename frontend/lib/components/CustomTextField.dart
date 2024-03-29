import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final bool isObscure;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.isObscure = true,
    this.onChanged,
    required bool obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      onChanged: onChanged,
      obscureText: isPassword ? isObscure : false,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: isPassword
            ? IconButton(
                icon: isObscure
                    ? const Icon(Icons.visibility_off, color: Colors.white)
                    : const Icon(Icons.visibility, color: Colors.white),
                onPressed: () {},
              )
            : null,
      ),
    );
  }
}
