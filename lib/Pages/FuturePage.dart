import 'package:flutter/material.dart';
import 'package:quiz_app/Dashboard/S_Dashboard/dashboardStudent.dart';

class FuturePage extends StatefulWidget {
  @override
  _FuturePageState createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> with WidgetsBindingObserver {

//To Implement Tab Switch Check add this line  " with WidgetsBindingObserver"

//Then add code form line 13 to 51
   int pause=0,resume=0,inactive=0,dead=0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setState(() {
      switch(state){
        case AppLifecycleState.paused:
          print('paused state');
          pause++;
          print(pause);
          break;
        case AppLifecycleState.resumed:
          print('resumed state');
          resume++;
          print(resume);
          break;
        case AppLifecycleState.inactive:
          print('inactive state');
          inactive++;
          print(inactive);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StudentDashboard()),
          );
          break;
        case AppLifecycleState.detached:
          print('suspending state');
          dead++;
          print(dead);
          break;
      }
    });
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
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
                "This Page Will Come in Next Update",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )),

          Center(
              child: Text(
                "Pause State: "+pause.toString(),
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )),

          Center(
              child: Text(
                "Inactive State: "+inactive.toString(),
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )),

          Center(
              child: Text(
                "Resume State: "+resume.toString(),
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )),
        ],
      ),
    );
  }
}
