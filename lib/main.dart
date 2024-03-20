import 'package:climate/screens/loading_screen.dart';
import 'package:flutter/material.dart';
//import 'screens/city_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const LoadingScreen()
    );
  }
}
