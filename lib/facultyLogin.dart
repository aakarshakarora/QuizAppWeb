import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_web_app/facultyDashboard.dart';
import 'package:quiz_web_app/facultyRegister.dart';
import 'package:quiz_web_app/startPage.dart';

class FacultyLogin extends StatefulWidget {
  @override
  _FacultyLoginState createState() => _FacultyLoginState();
}

class _FacultyLoginState extends State<FacultyLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: Text(
            "Login Registered Faculty",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Poppins'),
          ),
          //centerTitle: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StartPage()),
                  );
                },
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(50),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Registered and Verified User can Login',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                  ),
                  TextFormField(
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: 'Enter Email ID:',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 17,
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Field Required';
                      }
                      if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Enter Password:',
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17,
                      ),
                      suffixIcon: IconButton(
                        color: Colors.purpleAccent,
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    autofocus: false,
                    obscureText: _obscureText,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Field Required';
                      }
                      return null;
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Colors.deepPurpleAccent,
                      ),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        textColor: Colors.white,
                        padding: EdgeInsets.all(8.0),
                        splashColor: Colors.blueAccent,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _signInWithEmailAndPassword();
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Poppins'),
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    child: Text(
                      "Sign Up here!",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 17,
                          fontFamily: 'Poppins'),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => FacultyRegister()));
                    },
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _success == null
                          ? ''
                          : (_success
                          ? 'Successfully signed in ' + _userEmail
                          : 'Sign in failed'),
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmailAndPassword() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return FacultyDashboard();
          }),
        );
      });
    } else {
      setState(() {
        _success = false;
      });
    }
  }
}
