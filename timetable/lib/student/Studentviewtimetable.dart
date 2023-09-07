import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:timetable/timetable_view.dart';

class StudentViewTimetable extends StatefulWidget {
  const StudentViewTimetable({super.key});

  @override
  State<StudentViewTimetable> createState() => _StudentViewTimetableState();
}

class _StudentViewTimetableState extends State<StudentViewTimetable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Time Table')),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('timetableData')
            .orderBy('section')
            .get(),
        builder: (context, snap) {
          if (snap.hasData) {
            if (snap.data!.docs.isNotEmpty) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: ListView.builder(
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ViewTimeTable(
                                        section: snap.data!.docs[i]
                                            ['section'])));
                          },
                          trailing: const Icon(
                            Icons.arrow_circle_right_rounded,
                            size: 40,
                          ),
                          shape: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blueGrey, width: 2)),
                          title:
                              Text('Section: ${snap.data!.docs[i]['section']}'),
                        ),
                      );
                    }),
              );
            }
          }
          return const Center(
            child: Text('Loading...'),
          );
        },
      ),
    );
  }
}
