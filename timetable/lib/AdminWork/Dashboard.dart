import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timetable/AdminWork/HomeForAddS_T.dart';

import 'package:timetable/AdminWork/customcontainer.dart';
import 'package:timetable/Login.dart';
import 'package:timetable/navigatebysection.dart';

class selecting_categ extends StatefulWidget {
  const selecting_categ({super.key});

  @override
  State<selecting_categ> createState() => _selecting_categState();
}

class _selecting_categState extends State<selecting_categ> {
  final double horizontalPadding = 40;

  final double verticalPadding = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Admin',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Adjust the radius as needed
                          ),
                          title: const Text('Confirmation'),
                          content:
                              const Text('Are you sure you want to logout.'),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  tooltip: 'Logout',
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Row(children: [
                Center(
                  child: Text(
                    "Home",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.home,
                  color: Color.fromARGB(255, 0, 31, 85),
                )
              ]),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Perform Below Actions :",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                (MaterialPageRoute(
                    builder: (context) => const AdminTimeTableHome())));
          },
          child: customContainer(
            subtitle: 'TimeTable',
            text: 'Day',
            iimage: 'assets/images/time2.png',
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        InkWell(
          onTap: () {
            Navigator.push(context,
                (MaterialPageRoute(builder: (context) => const HomeForAdd())));
          },
          child: customContainer(
            subtitle: 'Teachers,Students,...',
            text: 'Add',
            iimage: 'assets/images/class.png',
          ),
        ),
      ]),
    );
  }
}

const List<String> days = [
  'Monday',
  'Tuesday',
  'Wednes',
  'Thurs',
  'Friday',
];
