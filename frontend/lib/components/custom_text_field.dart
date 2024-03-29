import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color textColor;
  final Color hintColor;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.textColor,
    required this.hintColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
