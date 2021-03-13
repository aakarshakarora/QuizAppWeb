import 'package:flutter/material.dart';
import 'package:quiz_web_app/facultyLogin.dart';


class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ignore: deprecated_member_use

            SizedBox(height: 15,),
            // ignore: deprecated_member_use
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
                "Faculty",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}