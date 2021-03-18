import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:math';

import 'package:quiz_app/CreateQuiz/addQuestion.dart';

class QuizDesc extends StatefulWidget {
  @override
  _QuizDescState createState() => _QuizDescState();
}

class _QuizDescState extends State<QuizDesc> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static String userID;
  String description;
  final descriptionController = TextEditingController();
  String subjectName;
  final subjectNameController = TextEditingController();
  int questionCount = 1;
  int marksPerQues = 1;
  DateTime startDate;
  DateTime endDate;
  DateTime requestDate = DateTime.now();
  bool startDateError = false;
  bool endDateError = false;
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String accessCode;
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  //Check Current User
  String getCurrentUser() {
    final User user = _auth.currentUser;
    final uid = user.uid;

    final uemail = user.email;
    print(uid);
    print(uemail);
    return uid.toString();
  }

  //Enter description
  _buildDescriptionField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: descriptionController,
        decoration: InputDecoration(labelText: 'Enter Description:'),
        // ignore: missing_return
        validator: (String value) {
          if (value.isEmpty) {
            return 'Field is required';
          }
        },
        onSaved: (String value) {
          description = value;
        },
      ),
    );
  }

  //Enter subjectName
  Widget _buildSubjectNameField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: subjectNameController,
        decoration: InputDecoration(labelText: 'Enter Subject Name:'),
        // ignore: missing_return
        validator: (String value) {
          if (value.isEmpty) {
            return 'Subject Name is required';
          }
        },
        onSaved: (String value) {
          subjectName = value;
        },
      ),
    );
  }

  //Slider for marks per question
  Widget _scoreCountSlider() {
    return Column(
      children: [
        Text("Marks Per Question: ",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Slider(
              min: 1,
              max: 10,
              activeColor: Colors.green,
              inactiveColor: Colors.grey,
              divisions: 10,
              value: marksPerQues.toDouble(),
              onChanged: (double value) {
                setState(() {
                  marksPerQues = value.round();
                  _formKey.currentState.save();
                  print("test");
                });
              }),
        ),
        Text(marksPerQues.toString(),
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
      ],
    );
  }

  //Question Count slider
  Widget _questionCount() {
    return Column(
      children: [
        Text("Question Count: ",
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Slider(
              min: 1,
              max: 50,
              inactiveColor: Colors.grey,
              divisions: 50,
              value: questionCount.toDouble(),
              onChanged: (double value) {
                setState(() {
                  questionCount = value.round();
                  _formKey.currentState.save();
                  print("test");
                });
              }),
        ),
        Text(questionCount.toString(),
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.black))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Faculty').doc(userID);
    setState(() {
      print(docRef.toString());
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          'Create Quiz',
          style:
              TextStyle(fontFamily: 'PoppinsBold', fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Form(
              key: _formKey,
              child: Column(children: [
                _buildDescriptionField(),
                _buildSubjectNameField(),
                _scoreCountSlider(),
                _questionCount(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Start:',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    //SizedBox(width: 0.1),
                    Column(
                      children: [
                        Container(
                          height: 41,
                          child: TextButton(
                            onPressed: () async {
                              await _startDate(context).then((value) {
                                if (endDate == null ||
                                    (endDate != null &&
                                        value.isBefore(endDate))) {
                                  setState(() {
                                    startDate = value.add(Duration(
                                        hours: startDate != null
                                            ? startDate.hour
                                            : 0,
                                        minutes: startDate != null
                                            ? startDate.minute
                                            : 0));
                                  });
                                } else if (endDate != null) {
                                  setState(() {
                                    startDate = endDate;
                                  });
                                }
                              });
                              if (startDate != null) {
                                await _selectTime(context).then((value) {
                                  if (value != null) {
                                    var newDate = startDate.add(Duration(
                                        hours: value.hour - startDate.hour,
                                        minutes:
                                            value.minute - startDate.minute));
                                    if (endDate != null &&
                                        newDate.isBefore(endDate)) {
                                      setState(() {
                                        startDate = newDate;
                                      });
                                    } else if (endDate == null) {
                                      setState(() {
                                        startDate = newDate;
                                      });
                                    } else {
                                      setState(() {
                                        startDate = endDate;
                                      });
                                    }
                                  }
                                });
                              }
                            },
                            child: Text(
                                startDate != null
                                    ? DateFormat('d MMM y on h:mm a')
                                        .format(startDate)
                                    : 'Select Date & Time',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 17,
                                    color: Colors.black)),
                          ),
                        ),
                        startDateError
                            ? Text(
                                "*Start Time is Required",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.red,
                                    fontSize: 15),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('End:',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    SizedBox(width: 22),
                    Column(
                      children: [
                        Container(
                          height: 41,
                          child: TextButton(
                            onPressed: () async {
                              await _endDate(context).then((value) {
                                if (startDate == null ||
                                    (startDate != null &&
                                        value.isAfter(startDate))) {
                                  setState(() {
                                    endDate = value.add(Duration(
                                        hours:
                                            endDate != null ? endDate.hour : 0,
                                        minutes: endDate != null
                                            ? endDate.minute
                                            : 0));
                                  });
                                } else if (startDate != null) {
                                  setState(() {
                                    endDate = startDate;
                                  });
                                }
                              });
                              if (endDate != null) {
                                await _selectTime(context).then((value) {
                                  if (value != null) {
                                    var newDate = endDate.add(Duration(
                                        hours: value.hour - endDate.hour,
                                        minutes:
                                            value.minute - endDate.minute));
                                    if (startDate != null &&
                                        newDate.isAfter(startDate)) {
                                      setState(() {
                                        endDate = newDate;
                                      });
                                    } else if (startDate == null) {
                                      setState(() {
                                        endDate = newDate;
                                      });
                                    } else {
                                      endDate = startDate;
                                    }
                                  }
                                });
                              }
                            },
                            child: Text(
                                endDate != null
                                    ? DateFormat('d MMM y on h:mm a')
                                        .format(endDate)
                                    : 'Select Date & Time',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 17,
                                    color: Colors.black)),
                          ),
                        ),
                        endDateError
                            ? Text(
                                "*End Time is Required",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.red,
                                    fontSize: 15),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Access Code :" + accessCode,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                Container(
                  //elevation: 5.0,
                  //color: colour,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.green,
                  ),
                  //borderRadius: BorderRadius.circular(30.0),
                  child: Builder(
                    builder: (BuildContext context) {
                      return MaterialButton(
                        onPressed: () async {
                          if ((startDate == null || endDate == null) &&
                              (_formKey.currentState.validate())) {
                            setState(() {
                              startDate == null ? startDateError = true : null;
                              endDate == null ? endDateError = true : null;
                            });
                          } else {
                            print("hello");
                            print(description);
                            print(subjectName);
                            print(descriptionController.toString());
                            if (_formKey.currentState.validate()) {
                              FirebaseFirestore.instance
                                  .collection('Quiz')
                                  .doc(accessCode)
                                  .set({
                                "Description": descriptionController.text,
                                "SubjectName": subjectNameController.text,
                                "AccessCode": accessCode,
                                "QuestionCount": questionCount,
                                "MarksPerQuestion": marksPerQues,
                                "MaxScore": marksPerQues * questionCount,
                                "startDate": startDate,
                                "endDate": endDate,
                                "CreationDate": requestDate,
                                "Creator": docRef
                              }).then((_) {
                                _displaySnackBar(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddQuestion(
                                          accessCode, questionCount)),
                                );
                              }).catchError((onError) {
                                _displayError(context, onError);
                              });
                            }
                          }
                        },
                        minWidth: 200.0,
                        height: 50.0,
                        child: Text(
                          'Add Questions',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ])),
        ),
      ),
    );
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(
        content: Text(
      'Desciption Added Successfully',
      style: TextStyle(fontFamily: 'Poppins'),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _displayError(BuildContext context, onError) {
    final snackBar = SnackBar(
        content: Text(
      onError,
      style: TextStyle(fontFamily: 'Poppins'),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //Select Start Date
  Future<DateTime> _startDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().toLocal(),
      firstDate: DateTime.now().toLocal(),
      lastDate: endDate ?? DateTime(2100),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
                // primary: Colors.blue,
                // onPrimary: white,
                // surface: peach,
                // onSurface: white,
                ),
            // dialogBackgroundColor: darkerBlue,
          ),
          child: child,
        );
      },
    );
    return picked.toLocal();
  }

  //Select Start Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final TimeOfDay selectedTime = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(
        DateTime.utc(0),
      ),
      context: context,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
                // primary: darkerBlue,
                // onPrimary: white,
                // surface: peach,
                // onSurface: darkerBlue,
                ),
          ),
          child: child,
        );
      },
    );
    return selectedTime;
  }

  //Select End Date
  Future<DateTime> _endDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now().toLocal(),
      firstDate: startDate ?? DateTime.now().toLocal(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
                // primary: peach,
                // onPrimary: white,
                // surface: peach,
                // onSurface: white,
                ),
            // dialogBackgroundColor: darkerBlue,
          ),
          child: child,
        );
      },
    );
    return picked.toLocal();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userID = getCurrentUser();
    accessCode = getRandomString(5);
  }

  @override
  void dispose() {
    super.dispose();
    subjectNameController.dispose();
    descriptionController.dispose();
  }
}
