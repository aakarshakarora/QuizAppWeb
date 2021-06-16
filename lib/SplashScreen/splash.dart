import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Dashboard/F_Dashboard/dashboardFaculty.dart';
import 'package:quiz_app/Dashboard/S_Dashboard/dashboardStudent.dart';
import 'package:quiz_app/Pages/startPage.dart';

//Status: Minor Issues are there

/*
Persistent Login and Role Check
*/

class SplashScreen extends StatefulWidget {
  final String text;

  SplashScreen({this.text});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: darkerBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              child: Text("Please Wait"),
            ),
          ),
          Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 5,
            ),
          )
        ],
      ),
    );
  }
}
