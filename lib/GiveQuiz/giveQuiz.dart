import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Dashboard/S_Dashboard/dashboardStudent.dart';
import 'package:quiz_app/GiveQuiz/attemptQuiz.dart';

class EnterCode extends StatefulWidget {
  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  final TextEditingController _accessCodeController = TextEditingController();

  _buildAccessCodeField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            labelText: 'Enter Access Code:',
            labelStyle: TextStyle(
              fontSize: 17,
              fontFamily: 'Poppins',
            )),
        keyboardType: TextInputType.text,
        controller: _accessCodeController,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Field Required';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Give Quiz"),
        ),
        body: Column(
          children: [
            _buildAccessCodeField(),
            TextButton(
              onPressed: () async {
                setState(() {
                  //print("The access code is: " + _accessCodeController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QuizCodeDesc(_accessCodeController.text)),
                  );
                });
              },
              child: Text("Submit"),
            ),
          ],
        ));
  }
}

class QuizCodeDesc extends StatefulWidget {
  final String accessCode;

  QuizCodeDesc(this.accessCode);

  @override
  _QuizCodeDescState createState() => _QuizCodeDescState();
}

class _QuizCodeDescState extends State<QuizCodeDesc> {
  static String code, facultyName;
  static int endTime, startTime, currentTime;
  Timestamp sTime, eTime,cTime;
  DateTime res1, res2;
  bool attempted = false;
  static bool  groupCheck;
  List studentGroup;

  int score = 0, tabSwitch = 0;
  final userId = FirebaseAuth.instance.currentUser.uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getUserID() {
    final User user = _auth.currentUser;
    final uid = user.uid;
    //print(uid);
    return uid.toString();
  }

  String getUserEmail() {
    final User user = _auth.currentUser;
    final uEmail = user.email;
    //print(uEmail);
    return uEmail.toString();
  }

  String uId, uName, uEmailId, uRegNo;

  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      code = widget.accessCode;
      super.initState();
      uId = getUserID();
      uEmailId = getUserEmail();
      FirebaseFirestore.instance
          .collection('Student')
          .doc(uId)
          .get()
          .then((value) {
        uName = value.data()['S_Name'];
        uRegNo = value.data()['S_RegNo'];
      });

      FirebaseFirestore.instance
          .collection('Quiz')
          .doc(code)
          .collection(code + 'Result')
          .doc(uId)
          .get()
          .then((value) async {
        attempted = await value.data()['attempted'];
        print("Login Status :$attempted");
      });
    });
  }

  _getFacultyName(DocumentReference documentReference) async {
    await documentReference.get().then((value) {
      setState(() {
        facultyName = value.data()['F_Name'];
      });
    });
  }
  _groupCheck(DocumentReference documentReference) async {
    await documentReference.get().then((value) {
      studentGroup = value.data()['AllottedStudent'];
    });

    if(studentGroup.contains(uId))
    {
      print("Yes, It contains UID");
      setState(() {
        groupCheck=true;

      });


    }

    else{
      print("No,It doesn't UID");
      setState(() {
        groupCheck=false;
      });
      print(groupCheck);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Description"),
      ),
      body: Center(
        child: Container(
          child: FutureBuilder<DocumentSnapshot>(
              future:
              FirebaseFirestore.instance.collection('Quiz').doc(code).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData && (facultyName == null)) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.data.exists == false) {
                  return Center(
                      child: Text(
                          "No Information Found!! \nKindly Enter Correct Access Code "));
                } else {
                  Map<String, dynamic> data = snapshot.data.data();
                  DocumentReference documentReference = data['Creator'];
                  DocumentReference groupRef=data['QuizGroup'];
                  _getFacultyName(documentReference);
                  _groupCheck(groupRef);
                  return Column(
                    children: [
                      Text('Subject Name:' + data['SubjectName']),
                      Text('Description: ' + data['Description']),
                      Text('Question Count: ' + data['QuestionCount'].toString()),
                      Text('Max  Score: ' + data['MaxScore'].toString()),
                      Text('Start Time: ' +
                          (data['startDate'] as Timestamp).toDate().toString()),
                      Text('End Time: ' +
                          (data['endDate'] as Timestamp).toDate().toString()),
                      Text("Creator Name:$facultyName "),
                      groupCheck==true?Text("You are allowed to give Quiz"):Text("You are not allowed to give Quiz"),
                      TextButton(
                          onPressed: () async {
                            sTime = (data['startDate']);
                            startTime = sTime.millisecondsSinceEpoch + 1000 * 30;

                            eTime = (data['endDate']);
                            endTime = eTime.millisecondsSinceEpoch + 1000 * 30;

                            currentTime=DateTime.now().millisecondsSinceEpoch + 1000 * 30;

                            print("Start Date: $startTime");
                            print("End Date: $endTime");
                            print("Current Date: $currentTime");
                            print("Attempted Check: "+attempted.toString());
                            print("Group Check:"+groupCheck.toString());

                            if (attempted == true &&groupCheck==false) {
                              //print("This is being called");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StudentDashboard()),
                              );
                            }

                            else if (attempted == false &&groupCheck==true) {
                              if (startTime <= currentTime && endTime >= currentTime)
                              {
                                FirebaseFirestore.instance
                                    .collection('Quiz')
                                    .doc(code)
                                    .collection(code + 'Result')
                                    .doc(uId)
                                    .set({
                                  'S_Name': uName,
                                  'S_UID': uId,
                                  'S_RegNo': uRegNo,
                                  'S_EmailID': uEmailId,
                                  'attempted': attempted,
                                  'Score': score,
                                  'tabSwitch': tabSwitch,
                                  'maxScore':data['MaxScore']
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AttemptQuiz(
                                        marksPerQuestion: data['MarksPerQuestion'],
                                        subjectName: data['SubjectName'],
                                        accessCode: code,
                                        questionCount: data['QuestionCount'],
                                        maximumScore: data['MaxScore'],
                                        timeCount: endTime,
                                      )),
                                );
                              }

                              else{
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StudentDashboard()),
                                );
                              }
                            }
                          },
                          child: Text("Give Quiz"))
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
