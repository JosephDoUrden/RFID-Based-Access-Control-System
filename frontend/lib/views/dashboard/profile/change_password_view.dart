import 'package:flutter/material.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text('Change Password'),
        ),
      ),
    );
  }
}
