import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Charts/pieChart.dart';

class ViewResult extends StatefulWidget {
  @override
  _ViewResultState createState() => _ViewResultState();
}

class _ViewResultState extends State<ViewResult> {

  final accessCodeController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("View Result"),
      ),

      body: Column(
        children: [
          TextFormField(
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                labelText: 'Enter Access Code:',
                labelStyle: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Poppins',

                )),
            keyboardType: TextInputType.text,
            controller: accessCodeController,
          ),
          MaterialButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PieChartDisplay(accessCodeController.text)),
                );
              },
              child: Text("See Score"))



        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class DisplayResult extends StatefulWidget {
  String accessCode;

  DisplayResult(this.accessCode);

  @override
  _DisplayResultState createState() => _DisplayResultState();
}

class _DisplayResultState extends State<DisplayResult> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uId,subjectName,creatorName,maxScore,quizDate;
  String getUserID() {
    final User user = _auth.currentUser;
    final uid = user.uid;
    print(uid);
    return uid.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uId = getUserID();
    String facultyName;

    _getFacultyName(DocumentReference documentReference) async {
      await documentReference.get().then((value) {
        setState(() {
          facultyName = value.data()['F_Name'];
        });
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    var firebaseDB = FirebaseFirestore.instance.collection('Quiz').doc(widget.accessCode)
        .collection(widget.accessCode+'Result').doc(uId).get();
    return
      Scaffold(
        body: FutureBuilder<DocumentSnapshot>(
            future: firebaseDB,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              Map<String, dynamic> data = snapshot.data.data();

              FirebaseFirestore.instance.collection('Quiz').doc(widget.accessCode).get().then((value) {
                DocumentReference documentReference = value.data()['Creator'];

                subjectName=value.data()['SubjectName'];
                maxScore=value.data()['MaxScore'].toString();
                quizDate=value.data()['startDate'].toString();
                print("Subject Name:"+subjectName);
                print("maxScore: "+maxScore);
                print("quizDate: "+quizDate);
                print("Code: "+widget.accessCode);

              });

              print(data['S_Name']);
              print(data['S_RegNo']);
              print(data['Score']);


              return Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Student Name:' + data['S_Name']),

                  Text('Registration Number: ' + data['S_RegNo']),
                  Text('Score : ' + data['Score'].toString()+'/ '+maxScore),
                  Text('Tab Switched: ' + data['tabSwitch'].toString()),
                  SizedBox(height: 10,),
                  Text('Subject Name:' + subjectName),
                  Text('Quiz Date: ' + quizDate),
                  Text("Creator Name: "  ),




                ],
              );
            }),
      );
  }
}




