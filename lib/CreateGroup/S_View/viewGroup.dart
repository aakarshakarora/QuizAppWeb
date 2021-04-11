import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/Charts/pieChart.dart';


class ViewGroups extends StatefulWidget {
  @override
  _ViewGroupsState createState() => _ViewGroupsState();
}

class _ViewGroupsState extends State<ViewGroups> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String currentUser,accessCode;

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
      appBar: AppBar(title: Text("View Group")),
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
              final reqDoc = data['GroupAdded'];
              return
                // Column(mainAxisAlignment: MainAxisAlignment.start,
                //     //crossAxisAlignment: CrossAxisAlignment.start,
                //     children: <Widget>[
                //       Text(data['QuizGiven'].toString()),
                //       Text(data['QuizGiven'].length.toString()),

                Container(
                  width: MediaQuery.of(context).size.width,
                  child: new ListView.builder(
                      itemCount: data['GroupAdded'].length,
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
                                        child: Text(reqDoc[index].toString().substring(65,reqDoc[index].toString().length-1)),
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
