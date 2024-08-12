import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(ChecklistApp());
}

class ChecklistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inspector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
