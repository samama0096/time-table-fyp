import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timetable/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData(
        appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 0, 31, 85),
    )),
    home: const LoginScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
