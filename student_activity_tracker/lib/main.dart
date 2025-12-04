import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Activity Tracker',
      theme: ThemeData(
        // Terapkan prinsip Material Design 3
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      // Set HomePage sebagai halaman awal
      home: const HomePage(), 
    );
  }
}