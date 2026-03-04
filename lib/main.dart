import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MemoriztaApp());
}

class MemoriztaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мемориста',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
