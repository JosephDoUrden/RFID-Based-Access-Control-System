import 'package:flutter/material.dart';
import 'package:frontend/views/onboarding_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RFID Based Access Control System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreenView(), // Uygulama başlangıç sayfası
    );
  }
}
