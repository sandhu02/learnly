import 'package:flutter/material.dart';
import 'package:learnly/views/splash_screen.dart';

class LearnlyApp extends StatelessWidget {
  const LearnlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learnly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
      ),

      // Make sure the splash loads first
      home: const Splashscreen(),
    );
  }
}
