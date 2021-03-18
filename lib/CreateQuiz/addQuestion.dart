import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Dashboard/F_Dashboard/dashboardFaculty.dart';
import 'package:quiz_app/Utilities/buttons.dart';

int currentCount = 1;

class AddQuestion extends StatefulWidget {
  @override
  AddQuestion(this.accessCode, this.questionCount);

  final String accessCode;
  final int questionCount;

  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  bool imagePresent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePresent = false;
  }

  final TextEditingController _imageLink = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _buildQuestionController =
      TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();

  _buildQuestionField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.bold),
        controller: _buildQuestionController,
        decoration: InputDecoration(
          labelText: 'Enter Question:',
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
          ),
        ),
        autofocus: false,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Field Required';
          }
          return null;
        },
      ),
    );
  }

  _buildImageCheck() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.bold),
        controller: _imageLink,
        decoration: InputDecoration(
          labelText: 'Enter Image URL:',
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
          ),
        ),
        autofocus: false,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Field Required';
          }
          return null;
        },
      ),
    );
  }

  _buildOption1Field() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.bold),
        controller: _option1Controller,
        decoration: InputDecoration(
          labelText: 'Option 1(Correct answer):',
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
          ),
        ),
        autofocus: false,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Field Required';
          }
          return null;
        },
      ),
    );
  }

  _buildOption2Field() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.bold),
        controller: _option2Controller,
        decoration: InputDecoration(
          labelText: 'Option 2:',
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
          ),
        ),
        autofocus: false,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Field Required';
          }
          return null;
        },
      ),
    );
  }

  _buildOption3Field() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.bold),
        controller: _option3Controller,
        decoration: InputDecoration(
          labelText: 'Option 3:',
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
          ),
        ),
        autofocus: false,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Field Required';
          }
          return null;
        },
      ),
    );
  }

  _buildOption4Field() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.bold),
        controller: _option4Controller,
        decoration: InputDecoration(
          labelText: 'Option 4:',
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
          ),
        ),
        autofocus: false,
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(currentCount.toString() +
                    "/" +
                    widget.questionCount.toString()),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Yes"),
                      Radio<bool>(
                          groupValue: imagePresent,
                          value: true,
                          onChanged: (v) {
                            setState(() {
                              imagePresent = v;
                            });
                          }),
                      Text("No"),
                      Radio<bool>(
                          groupValue: imagePresent,
                          value: false,
                          onChanged: (v) {
                            setState(() {
                              imagePresent = v;
                            });
                          }),
                    ],
                  ),
                ),
                imagePresent == true
                    ? _buildImageCheck()
                    : Container(
                        height: 0,
                      ),
                _buildQuestionField(),
                _buildOption1Field(),
                _buildOption2Field(),
                _buildOption3Field(),
                _buildOption4Field(),
                SizedBox(
                  height: 100,
                ),
                Row(
                  children: [
                    currentCount == widget.questionCount
                        ? roundedButton(
                            color: Colors.purple,
                            context: context,
                            text: 'Submit',
                            onPressed: () async {
                              print(_buildQuestionController.text);
                              print(_option1Controller.text);
                              print(_option2Controller.text);
                              print(_option3Controller.text);
                              print(_option4Controller.text);
                              if (_formKey.currentState.validate()) {
                                FirebaseFirestore.instance
                                    .collection('Quiz')
                                    .doc(widget.accessCode)
                                    .collection(widget.accessCode)
                                    .add({
                                  "01": _option1Controller.text,
                                  "02": _option2Controller.text,
                                  "03": _option3Controller.text,
                                  "04": _option4Controller.text,
                                  "Ques": _buildQuestionController.text,
                                  "imgPresent": imagePresent,
                                  "imgURL": _imageLink.text
                                }).then((_) {
                                  //_displaySnackBar(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FacultyDashboard()),
                                  );
                                }).catchError((error) {
                                  print(error);
                                });
                              }
                            })
                        : Container(),
                    currentCount < widget.questionCount
                        ? roundedButton(
                            color: Colors.purple,
                            context: context,
                            text: 'Add Question',
                            onPressed: () async {
                              print(_buildQuestionController.value);
                              print(_option1Controller.value);
                              print(_option2Controller.value);
                              print(_option3Controller.value);
                              print(_option4Controller.value);
                              if (_formKey.currentState.validate()) {
                                FirebaseFirestore.instance
                                    .collection('Quiz')
                                    .doc(widget.accessCode)
                                    .collection(widget.accessCode)
                                    .add({
                                  "01": _option1Controller.text,
                                  "02": _option2Controller.text,
                                  "03": _option3Controller.text,
                                  "04": _option4Controller.text,
                                  "Ques": _buildQuestionController.text,
                                  "imgPresent": imagePresent,
                                  "imgURL": _imageLink.text
                                }).then((_) {
                                  _displaySnackBar(context);
                                  setState(() {
                                    currentCount++;
                                    print(currentCount);
                                    print(widget.questionCount);
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => (AddQuestion(
                                            widget.accessCode,
                                            widget.questionCount))),
                                  );
                                }).catchError((error) {
                                  print(error);
                                });
                              }
                            })
                        : Container(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(
        content: Text(
      'Question Added Successfully',
      style: TextStyle(fontFamily: 'Poppins'),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
