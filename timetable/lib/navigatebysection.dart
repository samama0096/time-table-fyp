import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timetable/model_tt.dart';
import 'package:timetable/timetable_view.dart';
import 'firebase_service.dart';

class AdminTimeTableHome extends StatefulWidget {
  const AdminTimeTableHome({super.key});

  @override
  State<AdminTimeTableHome> createState() => _AdminTimeTableHomeState();
}

class _AdminTimeTableHomeState extends State<AdminTimeTableHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Table'),
        actions: [
          const Center(child: Text('Upload Teacher Wise')),
          IconButton(
              onPressed: () async {
                var e = await rootBundle.loadString('assets/prf-json.json');
                Map jsondata = jsonDecode(e);
                var teachers = jsondata.keys;
                bool res = false;
                var delete = await FirebaseFirestore.instance
                    .collection('teacherwisedata')
                    .get();
                for (DocumentSnapshot d in delete.docs) {
                  await d.reference.delete();
                }
                setState(() {});
                for (var teacher in teachers) {
                  List<TeacherByDay> tt = [];
                  var teacherData = jsondata[teacher] as List<dynamic>;
                  tt = teacherData
                      .map((e) =>
                          TeacherByDay.fromJson(e as Map<String, dynamic>))
                      .toList();

                  res = await FirebasService.uploadTeacherWiseData(tt, teacher);
                }
                print(res);
                setState(() {});
              },
              icon: const Icon(Icons.upload_file)),
          IconButton(
              onPressed: () async {
                var delete = await FirebaseFirestore.instance
                    .collection('sectionwisedata')
                    .get();
                for (DocumentSnapshot d in delete.docs) {
                  await d.reference.delete();
                }
                setState(() {});
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('sectionwisedata')
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var e = await rootBundle.loadString('assets/tt-json.json');
          Map jsondata = jsonDecode(e);
          var keys = jsondata.keys;
          for (var section in keys) {
            List<SectionTT> tt = [];
            var sectionData = jsondata[section] as List<dynamic>;
            tt = sectionData
                .map((e) => SectionTT.fromJson(e as Map<String, dynamic>))
                .toList();

            var res = await FirebasService.uploadData(tt, section);
            print(res);
          }
          setState(() {});
        },
        child: const Icon(Icons.upload),
      ),
    );
  }
}
