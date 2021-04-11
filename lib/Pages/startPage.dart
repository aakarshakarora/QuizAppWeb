import 'package:flutter/material.dart';
import 'package:quiz_app/Login/F_Login/loginFaculty.dart';
import 'package:quiz_app/Login/userLogin.dart';



class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserLogin()),
                );
              },
              child: Text(
                "Login",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FacultyLogin()),
                );
              },
              child: Text(
                "Sign Up",
                style: TextStyle(fontSize: 20.0),
              ),
            ),

          ],
        ),
      ),
    );
  }
}