import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/Dashboard/S_Dashboard/dashboardStudent.dart';

class OldResult extends StatefulWidget {
  @override
  _OldResultState createState() => _OldResultState();
}

class _OldResultState extends State<OldResult> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String currentUser,accessCode;

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

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Old Result")),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('Student')
                .doc(currentUser)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              Map<String, dynamic> data = snapshot.data.data();
              final reqDoc = data['QuizGiven'];
              return
                  // Column(mainAxisAlignment: MainAxisAlignment.start,
                  //     //crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(data['QuizGiven'].toString()),
                  //       Text(data['QuizGiven'].length.toString()),

                  Container(
                width: MediaQuery.of(context).size.width,
                child: new ListView.builder(
                    itemCount: data['QuizGiven'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Column(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                    elevation: 3.5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: FlatButton(
                                        child: Text(reqDoc[index].toString()),
                                        onPressed: () {

                                          setState(() {
                                            accessCode=reqDoc[index].toString().substring(0,5);
                                          });
                                          print(accessCode);

                                        },
                                      ),
                                    ))),
                          ],
                        ),
                      );
                    }),
              );
            }),
      ),
    );
  }
}
