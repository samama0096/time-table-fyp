import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timetable/Login.dart';
import 'package:timetable/navigatebysection.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _animationController?.forward();

    _timer = Timer(const Duration(seconds: 8), () {
      // Navigating to the next screen after 5 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/splash.jpg', // replace with your own Lottie animation file
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'TimeTable System',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 31, 85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
