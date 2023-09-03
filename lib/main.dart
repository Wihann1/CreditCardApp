import 'package:credit_card_capture_app/home_screen.dart';
import 'package:credit_card_capture_app/theme.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Title Off App
      title: 'Credit Card Capture App',
      theme: lightTheme, // Light theme
      darkTheme: darkTheme, // Dark theme
      //Go tohomepage
      home: const HomeScreen(),
    );
  }
}
