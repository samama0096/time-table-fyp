import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudReg extends StatefulWidget {
  const StudReg({Key? key}) : super(key: key);

  @override
  _StudRegState createState() => _StudRegState();
}

class _StudRegState extends State<StudReg> {
  late CollectionReference studentsRef;
  List<Map<String, dynamic>> studentList = [];
  bool isDeletingAll = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    studentsRef = FirebaseFirestore.instance.collection('students');
    fetchData();
  }

  Future<void> importStudent() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      if (file.path != null) {
        File csvFile = File(file.path!);
        String csvData = await csvFile.readAsString();

        if (csvData.isNotEmpty) {
          setState(() {
            isLoading = true; // Show loading state
          });

          List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);

          for (int i = 1; i < csvTable.length; i++) {
            List<dynamic> csvRow = csvTable[i];
            String name = csvRow[0].toString();
            String semester = csvRow[1].toString();
            String email = csvRow[2].toString();
            String password = csvRow[3].toString();

            if (password.length >= 6) {
              try {
                final authResult =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                await studentsRef.doc(authResult.user!.uid).set({
                  'name': name,
                  'semester': semester,
                  'email': email,
                  'role': 'Student',
                  'pascode': password,
                });
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('The password is too weak.')),
                  );
                } else if (e.code == 'email-already-in-use') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('The account already exists for that email.'),
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to create the account.')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'The password should be at least 6 characters long.'),
                ),
              );
            }
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('CSV data imported successfully!')),
          );

          fetchData();
          setState(() {
            isLoading = false; // Hide loading state
          }); // Fetch the updated data
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The selected file is empty.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to read the file path.')),
        );
      }
    }
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Show loading state
    });
    QuerySnapshot snapshot = await studentsRef.get();
    setState(() {
      studentList = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'semester': data['semester'] ?? '',
          'email': data['email'] ?? '',
          'role': data['role'] ?? '',
          'pascode': data['pascode'] ?? '',
        };
      }).toList();
      isLoading = false;
    });
  }

  Future<void> deleteData(String docId) async {
    try {
      DocumentSnapshot snapshot = await studentsRef.doc(docId).get();
      final data = snapshot.data() as Map<String, dynamic>;
      String email = data['email'];

      await studentsRef.doc(docId).delete();

      // Delete the user's authentication data
      await FirebaseAuth.instance.currentUser?.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data deleted successfully!')),
      );
      fetchData(); // Fetch the updated data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete data.')),
      );
    }
  }

  Future<void> deleteAllData() async {
    setState(() {
      isDeletingAll = true;
    });

    try {
      // Delete all documents in the 'students' collection
      await studentsRef.get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All data deleted successfully!')),
      );

      fetchData(); // Fetch the updated data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete all data.')),
      );
    } finally {
      setState(() {
        isDeletingAll = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Import CSV'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirmation'),
                    content:
                        Text('Are you sure you want to delete all courses?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          deleteAllData();
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  );
                },
              );
            },
            tooltip: 'Delete All',
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Show circular progress indicator
            )
          : GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: studentList.length,
              itemBuilder: (context, index) {
                final itemCount = index + 1;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color.fromARGB(255, 0, 31, 85).withOpacity(0.5),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    studentList[index]['name'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Icon(Icons.email),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Text(
                                      studentList[index]['email'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Icon(Icons.password),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    studentList[index]['pascode'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Icon(Icons.class_),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    studentList[index]['semester'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            itemCount.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            deleteData(studentList[index]['id']);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.black,
                            size: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: importStudent,
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 0, 31, 85),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
