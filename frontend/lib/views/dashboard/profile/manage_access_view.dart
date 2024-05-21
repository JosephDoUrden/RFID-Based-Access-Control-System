import 'package:flutter/material.dart';

class ManageAccessView extends StatefulWidget {
  const ManageAccessView({super.key});

  @override
  State<ManageAccessView> createState() => _ManageAccessViewState();
}

class _ManageAccessViewState extends State<ManageAccessView> {
  @override
  Widget build(BuildContext context) {
    // Implement the Manage Access view here
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Access'),
      ),
      body: const Center(
        child: Text('Manage Access Screen'),
      ),
    );
  }
}
