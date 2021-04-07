import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/CreateQuiz/addStudent.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String currentUser;

//Get Current User
  String getCurrentUser() {
    final User user = _auth.currentUser;
    final uid = user.uid;
    final uemail = user.email;
    print(uid);
    print(uemail);
    return uid.toString();
  }

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUser();
  }

  final accessCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Create New Group"),
            TextFormField(
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
              controller: accessCodeController,
            ),
            // ignore: deprecated_member_use
            FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddStudent(accessCodeController.text)),
                  );
                },
                child: Text("Create Group")),
            SizedBox(
              height: 20,
            ),
            Text('Old Group'),
            Expanded(
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
                    print('length ${reqDocs.length}');
                    return ListView.builder(
                      itemCount: reqDocs.length,
                      itemBuilder: (ctx, index) {
                        if (reqDocs != null)
                          return GroupNameInfo(reqDocs[index]);
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
        ),
      ),
    );
  }
}

class GroupNameInfo extends StatefulWidget {
  final dynamic reqDoc;

  GroupNameInfo(this.reqDoc);

  @override
  _GroupNameInfoState createState() => _GroupNameInfoState();
}

class _GroupNameInfoState extends State<GroupNameInfo> {
  @override
  Widget build(BuildContext context) {
    final name = widget.reqDoc.id;

    return Container(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        child: Card(
          elevation: 5,
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Group Name:',
                      // style: darkSmallTextBold,
                    ),
                    Text(
                      '$name',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
