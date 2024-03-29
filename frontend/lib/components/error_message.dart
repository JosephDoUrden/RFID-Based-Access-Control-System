import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final Color color;

  const ErrorMessage({
    Key? key,
    required this.message,
    this.color = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(
        color: color,
      ),
    );
  }
}
