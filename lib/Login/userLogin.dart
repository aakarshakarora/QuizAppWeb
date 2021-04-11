import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quiz_app/Dashboard/S_Dashboard/dashboardStudent.dart';
import 'package:quiz_app/Pages/startPage.dart';
import 'package:quiz_app/Register/S_Register/registerStudent.dart';
import 'package:quiz_app/SplashScreen/splash.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  bool _obscureText = true;
  bool showSpinner = false;
  String _error;

  //Shows Error Displayed from Console
  Widget _buildError() {
    setState(() {
      showSpinner = false;
    });
    if (_error != null) {
      return Container(
          padding: EdgeInsets.all(10),
          color: Colors.yellowAccent,
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.error),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(_error, overflow: TextOverflow.clip),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _error = null;
                      });
                    },
                  )
                ],
              ),
            ],
          ));
    } else {
      return Container(
        height: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            title: Text(
              "Registered User Login",
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
            child: Column(
              children: [
                _buildError(),
                Container(
                  padding: EdgeInsets.all(50),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Registered and Verified Student can Login',
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
                              setState(() {
                                showSpinner = false;
                              });
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
                              setState(() {
                                showSpinner = false;
                              });
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: Colors.deepPurpleAccent,
                            ),
                            child: MaterialButton(
                              textColor: Colors.white,
                              padding: EdgeInsets.all(10.0),
                              splashColor: Colors.blueAccent,
                              onPressed: () async {
                                await Future.value(_error);
                                setState(() {
                                  if (_error != null) {
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  } else {
                                    setState(() {
                                      showSpinner = true;
                                    });
                                  }
                                });
                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                                _formKey.currentState.save();
                                _signInWithEmailAndPassword();
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
                        TextButton(
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
                                    builder: (ctx) => StudentRegister()));
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
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmailAndPassword() async {
    print("SignIn is called");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
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
              return SplashScreen(text: "Logging You In....",);
            }),
          );
        });
      } else {
        setState(() {
          _success = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _error = e.message;
      });
    }
  }
}
