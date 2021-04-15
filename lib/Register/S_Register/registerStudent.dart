import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Login/userLogin.dart';

class StudentRegister extends StatefulWidget {
  StudentRegister({Key key}) : super(key: key);

  @override
  _StudentRegisterState createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  String role = "Student";
  bool showSpinner = false;

  TextEditingController studentNameController = new TextEditingController();
  TextEditingController emailIdInputController = new TextEditingController();
  TextEditingController pwdInputController = new TextEditingController();
  TextEditingController confirmPwdInputController = new TextEditingController();

  TextEditingController contactNumberInputController =
      new TextEditingController();

  TextEditingController courseNameController = new TextEditingController();

  TextEditingController registrationNoController = new TextEditingController();

  //Send Email Verification Code on Registered Email ID
  Future<void> sendEmailVerification() async {
    User user = await _firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  //Check if Field is Empty or not
  // ignore: missing_return
  String checkEmpty(String value) {
    if (value.isEmpty) {
      setState(() {
        showSpinner = false;
      });
      return 'Field Required';
    }
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'Password should be at least 6 characters';
    } else {
      return null;
    }
  }

  String validateMobile(String value) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Register",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                fontSize: 20)),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _registerFormKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Poppins',
                      )),
                  textCapitalization: TextCapitalization.words,
                  controller: studentNameController,
                  // ignore: missing_return
                  validator: (value) {},
                ),
                TextFormField(
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      helperText: "For App Registration",
                      helperStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                      ),
                      labelText: 'User Email ID',
                      labelStyle: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Poppins',
                      )),
                  controller: emailIdInputController,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),
                TextFormField(
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Poppins',
                      )),
                  controller: pwdInputController,
                  obscureText: true,
                  validator: pwdValidator,
                ),
                TextFormField(
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Poppins',
                      )),
                  controller: confirmPwdInputController,
                  obscureText: true,
                  validator: pwdValidator,
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                        "User Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            fontFamily: 'Poppins'),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            labelText: 'Student Contact Number:',
                            labelStyle: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Poppins',
                            )),
                        keyboardType: TextInputType.phone,
                        controller: contactNumberInputController,
                        validator: validateMobile,
                      ),
                      TextFormField(
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            labelText: 'Registration Number:',
                            labelStyle: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Poppins',
                            )),
                        keyboardType: TextInputType.phone,
                        controller: registrationNoController,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      TextFormField(
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            labelText: 'Course Name: ',
                            labelStyle: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Poppins',
                            )),
                        textCapitalization: TextCapitalization.words,
                        controller: courseNameController,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Register",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Poppins'),
                  ),
                  color: Colors.purple,
                  textColor: Colors.white,
                  onPressed: () {
                    if (_registerFormKey.currentState.validate()) {
                      if (pwdInputController.text ==
                          confirmPwdInputController.text) {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailIdInputController.text,
                                password: pwdInputController.text)
                            .then((currentUser) => FirebaseFirestore.instance
                                .collection("Student")
                                .doc(currentUser.user.uid)
                                .set({
                                  "UserID": currentUser.user.uid,
                                  "S_Name": studentNameController.text,
                                  "Role": role,
                                  "S_EmailId": emailIdInputController.text,
                                  "S_ContactNumber":
                                      contactNumberInputController.text,
                                  "S_Course": courseNameController.text,
                                  "S_RegNo": registrationNoController.text,
                                  "GroupAdded": FieldValue.arrayUnion([]),
                                  "QuizGiven": FieldValue.arrayUnion([]),
                                })
                                .then((result) => {
                                      sendEmailVerification(),
                                      FirebaseFirestore.instance
                                          .collection("User")
                                          .doc(currentUser.user.uid)
                                          .set({
                                        'U_Name': studentNameController.text
                                            .toUpperCase(),
                                        'Role': role,
                                        "UserID": currentUser.user.uid,
                                      }),
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserLogin()),
                                          (_) => false),
                                      emailIdInputController.clear(),
                                      pwdInputController.clear(),
                                      confirmPwdInputController.clear(),
                                      contactNumberInputController.clear(),
                                      studentNameController.clear(),
                                      courseNameController.clear(),
                                      registrationNoController.clear()
                                    })
                                .catchError((err) => print(err)))
                            .catchError((err) => print(err));
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Error"),
                                content: Text("The passwords do not match"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 18,
                ),
                Text(
                  "Already have an account?",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Poppins',
                      fontSize: 17),
                ),
                FlatButton(
                  child: Text(
                    "Login here!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Poppins'),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
