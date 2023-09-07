import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timetable/AdminWork/Dashboard.dart';
import 'package:timetable/teacher/teacher.dart';

import 'student/Studentviewtimetable.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Student';
  bool showEmoji = false;
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Login'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
                left: 25.0, bottom: 25.0, right: 25.0, top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Icon(
                        Icons.lock,
                        size: 200,
                      )),
                      Center(
                        child: Text(
                          'Login',
                        ),
                      ),
                    ]),
                Form(
                    child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          height: 60,
                          width: 160,
                          child: DropdownButtonFormField<String>(
                            borderRadius: BorderRadius.circular(20.0),
                            dropdownColor: Colors.grey[300],
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.person_outline_outlined,
                                color: Color.fromARGB(255, 0, 31, 85),
                              ),
                              labelText: 'Role',
                              // labelStyle: TextStyle(color: Color.fromARGB(255, 122, 122, 122)),
                              hintText: 'Select your role',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color.fromARGB(255, 0, 31, 85),
                              )),
                            ),
                            value: _selectedRole,
                            items: ['Student', 'Teacher', 'Admin']
                                .map((role) => DropdownMenuItem(
                                      value: role,
                                      child: Text(
                                        role,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Color.fromARGB(255, 0, 31, 85),
                          ),
                          label: Text(
                            'Email',
                            // style: TextStyle(color: Colors.black),
                          ),
                          // labelStyle: TextStyle(color: Color.fromARGB(255, 122, 122, 122)),
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 31, 85),
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.fingerprint,
                              color: Color.fromARGB(255, 0, 31, 85)),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 0, 31, 85),
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                showPassword =
                                    !showPassword; // Toggle the visibility of the password
                              });
                            },
                            child: Icon(
                              Icons.remove_red_eye_sharp,
                              color: showPassword
                                  ? const Color.fromARGB(255, 0, 31, 85)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        obscureText:
                            !showPassword, // Show/hide the password based on the toggle
                      ),
                      AnimatedOpacity(
                        opacity: showEmoji
                            ? 1.0
                            : 0.0, // Set the opacity based on visibility
                        duration: const Duration(
                            milliseconds: 200), // Set the animation duration
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.emoji_emotions,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: _login,
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                                letterSpacing: 1,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ));
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Show waiting animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Sign in with email and password
      final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final AdminDoc = await FirebaseFirestore.instance
          .collection('admin')
          .doc(authResult.user!.uid)
          .get();
      final AdminData = AdminDoc.data();
      if (AdminData != null &&
          AdminData.containsKey('role') &&
          AdminData.containsKey('name')) {
        final adminRole = AdminData['role'];
        final username = AdminData['name'];

        if (adminRole == 'Admin' && _selectedRole == 'Admin') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const selecting_categ(),
            ),
          ).then((_) {
            _emailController.clear();
            _passwordController.clear();
          }).whenComplete(() {
            Navigator.pop(context);
          });
          print('Logged in as a student: $username');
          return;
        }
      }

      final studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(authResult.user!.uid)
          .get();
      final studentData = studentDoc.data();
      if (studentData != null &&
          studentData.containsKey('role') &&
          studentData.containsKey('name')) {
        final studentRole = studentData['role'];
        final username = studentData['name'];
        final semester = studentData['semester'];
        if (studentRole == 'Student' && _selectedRole == 'Student') {
          // Update the device token in the student's collection
          final studentRef = FirebaseFirestore.instance
              .collection('students')
              .doc(authResult.user!.uid);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StudentViewTimetable(),
            ),
          ).then((_) {
            _emailController.clear();
            _passwordController.clear();
          }).whenComplete(() {
            Navigator.pop(context);
          });
          print('Logged in as a student: $username');
          return;
        }
      }

      // Get the teacher's role from the 'users' collection in Firestore
      final teacherDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .get();
      print(teacherDoc.data());
      final teacherData = teacherDoc.data();
      if (teacherData != null &&
          teacherData.containsKey('role') &&
          teacherData.containsKey('name')) {
        final teacherRole = teacherData['role'];
        final teacherName = teacherData['name'];

        // Navigate to the appropriate screen based on the teacher's role
        if (teacherRole == 'Teacher' && _selectedRole == 'Teacher') {
          // Update the device token in the student's collection
          final TeacherRef = FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherViewTimetable(
                name: teacherDoc['name'],
              ),
            ),
          ).then((_) {
            // Clear text fields when returning from Teacher_Selection screen
            _emailController.clear();
            _passwordController.clear();
          }).whenComplete(() {
            // Hide the waiting animation
            Navigator.pop(context);
          });
          print('Logged in as a teacher: $teacherName');
          return;
        }
      }

      // Show an error message if the user's role doesn't match the selected role
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email, password, or role selection.'),
        ),
      );
      print('Invalid email, password, or role selection.');
    } on FirebaseAuthException catch (e) {
      // Show an error message if there was an issue with authentication
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
      print('Error during login: ${e.message}');
    } catch (e) {
      // Show a generic error message if there was an unknown issue
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
        ),
      );
      print('An error occurred during login: $e');
    }

    // Hide the waiting animation
    Navigator.pop(context);

    // Clear text fields when returning from any other screen
    _emailController.clear();
    _passwordController.clear();
  }
}
