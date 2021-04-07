import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Dashboard/F_Dashboard/dashboardFaculty.dart';



class AddStudent extends StatefulWidget {
  final String groupName;

  AddStudent(this.groupName);

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userId = FirebaseAuth.instance.currentUser.uid;
  User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUser();

  }

//Get Current User
  User getCurrentUser() {
    final User user = _auth.currentUser;
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text("Add Student in "+widget.groupName),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FacultyDashboard()),
                  );
                })),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Student')
                  // .where("mentorEmailId", isNotEqualTo: mentorEmail)
                      .snapshots(),
                  builder: (ctx, opSnapshot) {
                    if (opSnapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    var reqDocs = opSnapshot.data.documents;
                    print('length ${reqDocs.length}');
                    return ListView.builder(
                      itemCount: reqDocs.length,
                      itemBuilder: (ctx, index) {
                        if (opSnapshot.hasData)
                          return ViewDetails(reqDoc:reqDocs[index], userID:currentUser.uid,groupName:widget.groupName);
                        return Container(
                          height: 0,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

class ViewDetails extends StatefulWidget {
  final dynamic reqDoc;
  final String userID;
  final String groupName;

  ViewDetails({this.reqDoc, this.userID,this.groupName});

  @override
  _ViewDetailsState createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {

  dynamic mentorFirestoreDB;

  // Future<void> _onPressed() async {
  //   mentorFirestoreDB =
  //       FirebaseFirestore.instance.collection('Faculty').doc(widget.userID);
  //   await mentorFirestoreDB.get().then((document) {
  //     mentorName = document.data()["F_Name"];
  //     mentorContactNumber = document.data()["F_ContactNumber"];
  //   });
  //   print("Mentor name is: " + mentorName);
  //   print("Mentor contact no is: " + mentorContactNumber);
  // }

  @override
  Widget build(BuildContext context) {
    //_onPressed();
    final studentName = widget.reqDoc.get("S_Name");
    final courseName = widget.reqDoc.get("S_Course");
    final regNo = widget.reqDoc.get("S_RegNo");
    final userID = widget.reqDoc.get("UserID");
    return Container(
        padding: const EdgeInsets.all(10),
        child: Container(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              child: Card(
                elevation: 5,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Text('Student Name: ',
                              // style: darkSmallTextBold,
                            ),
                            Text('$studentName',),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Registration Number: ',
                              // style: darkSmallTextBold,
                            ),
                            Text('$regNo', ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Course Name: '
                              // style: darkSmallTextBold,
                            ),
                            Text('$courseName'),
                          ],
                        ),

                        // ignore: deprecated_member_use
                      ],
                    ),
                    trailing: Column(
                      children: [
                        GestureDetector(
                            child: MaterialButton(
                              onPressed: () {

                                print("User ADDED");

                                print(widget.userID);
                                print(widget.groupName);
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection('Faculty')
                                      .doc(widget.userID).collection('QuizGroup').doc(widget.groupName)
                                      .update({
                                    "AllottedStudent": FieldValue.arrayUnion([userID])
                                  });
                                  print(userID);
                                  // FirebaseFirestore.instance
                                  //     .collection('Student')
                                  //     .doc(userID)
                                  //     .update({
                                  //
                                  // });
                                });
                              },
                              child: Icon(Icons.group_add),
                            )),
                        Text("Add User")
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
