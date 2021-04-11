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
  String _userID;
  String _switchCode;

  Future<void> startTimer() async {
     var _duration = Duration(seconds: 5);
    return  Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
     switch (_switchCode) {
      case 'not_logged_in':
        {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => StartPage()));
        }
        break;
      case 'not_verified':{
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => StartPage()));
      }
      break;
      case 'Student':
        {
          print("User is Student");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentDashboard()),
          );
        }
        break;
      case 'Faculty':
        {
          print("User is Faculty");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FacultyDashboard()),
          );

        }
        break;

    }
  }

  void _roleCheck(String userID) {
    print("inside role check");
    FirebaseFirestore.instance
        .collection('User')
        .doc(userID)
        .get()
        .then((value) {
      if (value.exists) {
        _switchCode = value.data()['Role'];
        print("$_switchCode");
      } else {
        print("ERROR");
      }
    });
  }


   initState()  {
    print("inside init");
    super.initState();
      startTimer();
    var _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _userID = _user.uid;
      if (_user.emailVerified == true){
        print("user id : $_userID");
      _roleCheck(_userID);
    }else{
        _switchCode='not_verified';
        _user.sendEmailVerification();
      }

    } else {
      _switchCode = 'not_logged_in';
    }
  }
//  void initState() {
//    print("inside init");
//    super.initState();
//
//    var _user = FirebaseAuth.instance.currentUser;
//    if (_user != null) {
//      if (!_user.emailVerified) {
//        setState(() {
//          Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => LoginPage()),
//          );
//        });
//      } else {
//        setState(() {
//          _userID = _user.uid;
//          print("user id : $_userID");
//          _roleCheck(_userID);
//        });
//        //Verified
//      }
//    } else {
//      _userID = _user.uid;
//      print("user id : $_userID");
//      _roleCheck(_userID);
//      _switchCode = 'not_logged_in';
//    }
//  }

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
