import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/CreateQuiz/addStudent.dart';
import 'package:quiz_app/CreateQuiz/quizDesc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Dashboard/F_Dashboard/dashboardFaculty.dart';

import 'editGroup.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String currentUser;
  final _groupNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


//Get Current User
  String getCurrentUser() {
    final User user = _auth.currentUser;
    final uid = user.uid;
    final uemail = user.email;
    // print(uid);
    // print(uemail);
    return uid.toString();
  }

  createGroupDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Create Group"),
            content: Form(
              key: _formKey,
              child: Container(
                child: TextFormField(
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      labelText: 'Enter Group Name:',
                      labelStyle: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Poppins',
                      )),
                  keyboardType: TextInputType.text,
                  controller: _groupNameController,
                  // ignore: missing_return
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Field is required';
                    }
                  },
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {

                    DocumentReference documentReference = FirebaseFirestore.instance
                          .collection('Faculty')
                          .doc(currentUser)
                          .collection('QuizGroup')
                          .doc(_groupNameController.text);
                    if (_groupNameController.text.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection('Faculty')
                          .doc(currentUser)
                          .collection('QuizGroup')
                          .doc(_groupNameController.text)
                          .set({"AllottedStudent": null});
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddStudent(_groupNameController.text, documentReference)));
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Group Name Should Not be Empty"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    }
                  },
                  child: Text("Add"))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUser();
    //print("The document reference of the teacher is:"+(Provider.of<Data>(context).docRef).toString());
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: Provider.of<Data>(context).showSpinner,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            createGroupDialog(context);
          },
        ),
        appBar: AppBar(
          title: Text("Quiz Groups"),

            leading: IconButton(


                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FacultyDashboard()),
                  );
                })

        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Faculty')
                  .doc(currentUser)
                  .collection('QuizGroup')
                  .snapshots(),
              builder: (ctx, opSnapshot) {
                if (opSnapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                final reqDocs = opSnapshot.data.documents;
               // print('length ${reqDocs.length}');
                return ListView.builder(
                  itemCount: reqDocs.length,
                  itemBuilder: (ctx, index) {
                    if (reqDocs != null)
                      return GroupNameInfo(
                        reqDoc: reqDocs[index],
                        currentUser: currentUser,
                      );
                    return Container(
                      height: 0,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class GroupNameInfo extends StatefulWidget {
  final dynamic reqDoc;
  final String currentUser;

  GroupNameInfo({this.reqDoc, this.currentUser});

  @override
  _GroupNameInfoState createState() => _GroupNameInfoState();
}

class _GroupNameInfoState extends State<GroupNameInfo> {
  bool spinnerStatus;
  dynamic groupFirestoreDB;
  List<dynamic> allottedStudentList;

  Future<void> _getGroupData() async {
    groupFirestoreDB = FirebaseFirestore.instance
        .collection('Faculty')
        .doc(widget.currentUser)
        .collection('QuizGroup')
        .doc(widget.reqDoc.id);
    await groupFirestoreDB.get().then((document) {
      allottedStudentList = document.data()["AllottedStudent"];
    });
    print("The student enrolled within this group are:" +
        allottedStudentList.toString());
  }


  createDeleteConfirmation(BuildContext context, dynamic reqDoc) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text(
                "Do you want to delete this group? \n All the students added will be removed as well"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                  onPressed: () async {
                    Provider.of<Data>(context, listen: false)
                        .changeSpinnerStatus(true);
                    DocumentReference documentReference = FirebaseFirestore.instance
                        .collection('Faculty')
                        .doc(widget.currentUser)
                        .collection('QuizGroup')
                        .doc(widget.reqDoc.id);
                    for (var studentDocumentID in allottedStudentList) {
                      DocumentReference docRef = FirebaseFirestore.instance
                          .collection('Student')
                          .doc(studentDocumentID);
                      DocumentSnapshot doc = await docRef.get();
                      List tags = doc.data()['GroupAdded'];
                      if(tags.contains(documentReference.toString())==true){
                        docRef.update({
                          'GroupAdded': FieldValue.arrayRemove([documentReference.toString()])
                        });
                      }
                    }
                    await FirebaseFirestore.instance
                        .runTransaction((Transaction myTransaction) async {
                      await myTransaction.delete(reqDoc.reference);
                    });
                    Navigator.of(context).pop();
                    Provider.of<Data>(context, listen: false)
                        .changeSpinnerStatus(false);
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getGroupData();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.reqDoc.id;
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('Faculty')
        .doc(widget.currentUser)
        .collection('QuizGroup')
        .doc(name);

    return Container(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        height: 100,
        child: InkWell(
          hoverColor: Colors.blue,
          onTap: () {
            //print(docRef.toString());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizDesc(docRef)),
            );
          },
          child: Card(
            elevation: 5,
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 30,
                    fit: FlexFit.tight,
                    child: Text(
                      '$name',
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        createDeleteConfirmation(context, widget.reqDoc);
                      },
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditGroup(name)),
                            );
                          }))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Data extends ChangeNotifier {
  bool showSpinner = false;
  void changeSpinnerStatus(bool isSpinning) {
    showSpinner = isSpinning;
    notifyListeners();
  }
}
