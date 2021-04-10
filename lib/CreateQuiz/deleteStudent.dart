import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'createGroup.dart';
class DeleteStudent extends StatefulWidget {
  final String groupName;
  final DocumentReference docRef;

  DeleteStudent(this.groupName, this.docRef);

  @override
  _DeleteStudentState createState() => _DeleteStudentState();
}

class _DeleteStudentState extends State<DeleteStudent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userId = FirebaseAuth.instance.currentUser.uid;
  User currentUser;
  List studentGroup;

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
            title: Text("Delete Student from " + widget.groupName),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateGroup()),
                  );
                })),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Student')
                      .where("GroupAdded",arrayContains: widget.docRef.toString())
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
                        if (opSnapshot.hasData) {
                          if (reqDocs[index]
                              .get('GroupAdded')
                              .contains(widget.docRef.toString()) ==
                              true) {
                            return ViewDetails(
                              reqDoc: reqDocs[index],
                              userID: currentUser.uid,
                              groupName: widget.groupName,
                              docRef: widget.docRef,
                            );
                          } else
                          {
                            return Container(
                              height: 0,

                            );
                          }
                        }

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
  final DocumentReference docRef;

  ViewDetails({this.reqDoc, this.userID, this.groupName, this.docRef});

  @override
  _ViewDetailsState createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  dynamic mentorFirestoreDB;

  @override
  Widget build(BuildContext context) {
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Student Name: ',
                              // style: darkSmallTextBold,
                            ),
                            Text(
                              '$studentName',
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Registration Number: ',
                              // style: darkSmallTextBold,
                            ),
                            Text(
                              '$regNo',
                            ),
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
                                print("User DELETED");

                                print(widget.userID);
                                print(widget.groupName);

                                print("Hello: " + widget.docRef.toString());
                                setState(() async {
                                  DocumentReference docRefFaculty = FirebaseFirestore.instance
                                      .collection('Faculty')
                                      .doc(widget.userID)
                                      .collection('QuizGroup')
                                      .doc(widget.groupName);
                                  DocumentSnapshot docFaculty = await docRefFaculty.get();
                                  List tagsFaculty = docFaculty.data()['AllottedStudent'];
                                  if(tagsFaculty.contains(userID)==true){
                                    docRefFaculty.update({
                                      'AllottedStudent': FieldValue.arrayRemove([userID])
                                    });
                                  }
                                  print(userID);
                                  DocumentReference docRefStudent  = FirebaseFirestore.instance
                                      .collection('Student')
                                      .doc(userID);
                                  DocumentSnapshot docStudent = await docRefStudent.get();
                                  List tagsStudent = docStudent.data()['GroupAdded'];
                                  if(tagsStudent.contains(widget.docRef.toString())==true){
                                    docRefStudent.update({
                                      'GroupAdded': FieldValue.arrayRemove([widget.docRef.toString()])
                                    });
                                  }
                                });
                              },
                              child: Icon(Icons.delete),
                            )),
                        Text("Add User",
                          style: TextStyle(
                              fontSize: 13
                          ),)
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}