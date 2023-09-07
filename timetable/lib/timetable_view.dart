import 'package:flutter/material.dart';
import 'package:timetable/firebase_service.dart';
import 'package:timetable/model_tt.dart';

class ViewTimeTable extends StatefulWidget {
  const ViewTimeTable({super.key, required this.section});
  final String section;
  @override
  State<ViewTimeTable> createState() => _ViewTimeTableState();
}

class _ViewTimeTableState extends State<ViewTimeTable> {
  List<int> slots = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<String> slotTimes = [
    '08:30  to  09:30  AM',
    '09:30  to  10:30  AM',
    '10:30  to  11:30  AM',
    '11:30  to  12:30  PM',
    '12:30  to  01:30  PM',
    '01:30  to  02:30  PM',
    '02:30  to  03:30  PM',
    '03:30  to  04:30  PM',
    '04:30  to  05:30  PM',
    '05:30  to  06:30  PM'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Section :  ${widget.section}')),
      body: FutureBuilder(
          future: FirebasService.getTtData(widget.section),
          builder: (context, snap) {
            if (snap.hasData) {
              print(snap.data!.length);

              //  res.then((sectionData) {
              //    for (var day in sectionData.docs) {
              //      print(day.data());
              //      sectionTT.add(SectionTT.fromJson(day.data()));
              //    }
              //  });

              return Center(
                child: ListView.builder(
                    itemCount: snap.data!.length,
                    itemBuilder: (context, i) {
                      SectionTT dayData = snap.data![i];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          title: Text(
                            ' ${dayData.day}',
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w600,
                                fontSize: 22),
                          ),
                          children: slots.map((e) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(10),
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: Colors.blueGrey, width: 2)),
                                title: Text('Slot# $e',
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18)),
                                trailing: Text(slotTimes[e - 1]),
                                subtitle: getString(e, dayData) == 'free'
                                    ? const Text('Free')
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                                ' Instructor:   ${getString(e, dayData)!.split(',').first}'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                                ' Course:   ${getString(e, dayData)!.split(',')[1]}'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                                ' Room#   ${getString(e, dayData)!.split(',')[2]}'),
                                          ),
                                        ],
                                      ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),
              );
            }

            return const Center(
              child: Text('Loading...'),
            );
          }),
    );
  }
}

String? getString(int slot, SectionTT tt) {
  if (slot == 1) {
    return tt.s0830;
  }
  if (slot == 2) {
    return tt.s0930;
  }
  if (slot == 3) {
    return tt.s1030;
  }
  if (slot == 4) {
    return tt.s1130;
  }
  if (slot == 5) {
    return tt.s1230;
  }
  if (slot == 6) {
    return tt.s0130;
  }
  if (slot == 7) {
    return tt.s0230;
  }
  if (slot == 8) {
    return tt.s0330;
  }
  if (slot == 9) {
    return tt.s0430;
  }
  if (slot == 10) {
    return tt.s0530;
  }
  return null;
}
