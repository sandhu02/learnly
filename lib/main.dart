import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learnly/views/learnly_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  runApp(const LearnlyApp());
}
