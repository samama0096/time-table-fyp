import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_tt.dart';

class FirebasService {
  static Future<bool> uploadData(List<SectionTT> tt, String section) async {
    var sectionDoc = FirebaseFirestore.instance.collection('sectionwisedata');
    try {
      await sectionDoc.add({'section': section}).then((value) async {
        for (var day in tt) {
          await sectionDoc
              .doc(value.id)
              .collection('byday')
              .doc(day.day)
              .set(SectionTT.toJson(day));
        }
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> uploadTeacherWiseData(
      List<TeacherByDay> tt, String teacher) async {
    var teacherDoc = FirebaseFirestore.instance.collection('teacherwisedata');
    try {
      await teacherDoc.add({'teacher': teacher}).then((value) async {
        for (var daydata in tt) {
          await teacherDoc
              .doc(value.id)
              .collection('byday')
              .doc(daydata.day)
              .set(TeacherByDay.toJson(daydata));
        }
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<TeacherByDay>> getTeacherWiseData(String name) async {
    var e = await FirebaseFirestore.instance
        .collection('teacherwisedata')
        .where('teacher', isEqualTo: name)
        .get();
    var res = e.docs.first;
    var res2 = await FirebaseFirestore.instance
        .collection('teacherwisedata')
        .doc(res.id)
        .collection('byday')
        .get();
    List<TeacherByDay> daysData =
        res2.docs.map((e) => TeacherByDay.fromJson(e.data())).toList();
    return daysData;
  }

  static Future<List<SectionTT>> getTtData(String section) async {
    List<SectionTT> ttList = [];
    var res = await FirebaseFirestore.instance
        .collection('sectionwisedata')
        .where('section', isEqualTo: section)
        .get();
    var data = res.docs.first;
    var res2 = await FirebaseFirestore.instance
        .collection('sectionwisedata')
        .doc(data.id)
        .collection('byday')
        .orderBy(FieldPath.documentId)
        .get();

    for (var day in res2.docs) {
      ttList.add(SectionTT.fromJson(day.data()));
    }
    return ttList;
  }
}
