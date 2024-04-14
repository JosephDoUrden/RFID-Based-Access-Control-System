import 'package:flutter/material.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text('Edit Profile'),
        ),
      ),
    );
  }
}
