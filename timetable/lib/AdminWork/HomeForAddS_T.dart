import 'package:flutter/material.dart';
import 'package:timetable/AdminWork/AddStudent.dart';
import 'package:timetable/AdminWork/AdminAddteacher.dart';

class HomeForAdd extends StatefulWidget {
  const HomeForAdd({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeForAdd> createState() => _HomeForAddState();
}

class _HomeForAddState extends State<HomeForAdd> {
  List<Widget> screens = [];
  int crntIndex = 0;

  @override
  void initState() {
    super.initState();
    screens = [
      TeacherRegistrationScreen(),
      StudReg(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const iconColor = Colors.black;
    const activeIconColor = Color.fromARGB(255, 0, 31, 85);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: screens[crntIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 0, 31, 85),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            selectedItemColor: activeIconColor,
            unselectedItemColor: iconColor,
            currentIndex: crntIndex,
            onTap: (int i) {
              setState(() {
                crntIndex = i;
              });
            },

            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.subject),
                label: 'Teacher',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_add),
                label: 'Student',
              ),
            ],

            // Change the icon color
          ),
        ),
      ),
    );
  }
}
