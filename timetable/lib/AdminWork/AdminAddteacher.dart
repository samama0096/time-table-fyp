import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherRegistrationScreen extends StatefulWidget {
  const TeacherRegistrationScreen({super.key});

  @override
  _TeacherRegistrationScreenState createState() =>
      _TeacherRegistrationScreenState();
}

class _TeacherRegistrationScreenState extends State<TeacherRegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  bool _registrationSuccess = false;
  Timer? _timer;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _timer?.cancel(); // Cancel the timer if it's active
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Instructor Registration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  const Center(
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 52),
                    ),
                  ),
                  const Center(
                    child: Text('Teachers Here!', style: TextStyle()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 0, 31, 85),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color.fromARGB(255, 0, 31, 85),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add additional email validation if needed
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Color.fromARGB(255, 0, 31, 85),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  // Add additional password validation if needed
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _registrationSuccess
                      ? const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: _register,
                              child: Container(
                                width: 20,
                                height: 40,
                                color: const Color(0xFFFFFFFF),
                                child: const Center(
                                  child: Text(
                                    'Register',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      letterSpacing: 1,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_validateForm()) {
      setState(() {
        _isLoading = true;
      });

      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        // Create a new user account
        final authResult =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Add the user's name and role to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({'name': name, 'role': 'Teacher', 'email': email});

        setState(() {
          _isLoading = false;
          _registrationSuccess = true;
        });

        _timer = Timer(const Duration(seconds: 2), () {
          setState(() {
            _registrationSuccess = false;
            _nameController.clear();
            _emailController.clear();
            _passwordController.clear();
          });
        });
        // Navigate to the student login screen
      } on FirebaseAuthException catch (e) {
        // Show an error message if there was an issue with authentication
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message!),
        ));
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        // Show a generic error message if there was an unknown issue
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('An error occurred. Please try again.'),
        ));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateForm() {
    if (_nameController.text.isEmpty) {
      _showErrorSnackBar('Please enter your name');
      return false;
    }
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar('Please enter your email');
      return false;
    }
    if (_passwordController.text.isEmpty) {
      _showErrorSnackBar('Please enter a password');
      return false;
    }

    // Add additional form validations if needed

    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
