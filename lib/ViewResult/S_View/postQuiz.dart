import 'package:flutter/material.dart';
import 'package:quiz_app/Dashboard/S_Dashboard/dashboardStudent.dart';


class PostQuiz extends StatefulWidget {
  final int score,inactive,totalScore;
  PostQuiz({@required this.score,@required this.inactive,@required this.totalScore});

  @override
  _PostQuizState createState() => _PostQuizState();
}

class _PostQuizState extends State<PostQuiz> {

  Future<bool> _onBackPressed(){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => StudentDashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            "Upcoming Page",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        body: Column(
          children: [
            Center(
                child: Text(
                  "Thank You for Giving Quiz !! \n Your Score is: "+widget.score.toString()+"/${widget.totalScore}\n Inactive State: "+widget.inactive.toString() ,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                )),
            TextButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentDashboard()),
              );
            }, child: Text("Go to Home"))
          ],


        ),
      ),
    );
  }
}