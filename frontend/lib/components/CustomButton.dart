import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue[900],
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }
}
