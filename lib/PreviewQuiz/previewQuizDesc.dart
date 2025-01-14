import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app/PreviewQuiz/previewQuiz.dart';

class PreviewQuizDesc extends StatefulWidget {
  final String subjectName, accessCode, description;
  final DateTime sDate, eDate;
  final int questionCount, maximumScore;

  PreviewQuizDesc({
    @required this.accessCode,
    @required this.subjectName,
    @required this.description,
    @required this.sDate,
    @required this.eDate,
    @required this.questionCount,
    @required this.maximumScore,
  });

  @override
  _PreviewQuizDescState createState() => _PreviewQuizDescState();
}

class _PreviewQuizDescState extends State<PreviewQuizDesc> {
  String subjectName, accessCode, description;
  TextEditingController sName, desc;
  DateTime startDate;
  DateTime endDate;
  DateTime requestDate = DateTime.now();
  bool startDateError = false;
  bool endDateError = false;

  Future<DateTime> _startDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().toLocal(),
      firstDate: DateTime.now().toLocal(),
      lastDate: endDate ?? DateTime(2100),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              // primary: Colors.blue,
              // onPrimary: white,
              // surface: peach,
              // onSurface: white,
            ),
            // dialogBackgroundColor: darkerBlue,
          ),
          child: child,
        );
      },
    );
    return picked.toLocal();
  }

  //Select Start Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final TimeOfDay selectedTime = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(
        DateTime.utc(0),
      ),
      context: context,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              // primary: darkerBlue,
              // onPrimary: white,
              // surface: peach,
              // onSurface: darkerBlue,
            ),
          ),
          child: child,
        );
      },
    );
    return selectedTime;
  }

  //Select End Date
  Future<DateTime> _endDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now().toLocal(),
      firstDate: startDate ?? DateTime.now().toLocal(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              // primary: peach,
              // onPrimary: white,
              // surface: peach,
              // onSurface: white,
            ),
            // dialogBackgroundColor: darkerBlue,
          ),
          child: child,
        );
      },
    );
    return picked.toLocal();
  }

  @override
  void initState() {
    super.initState();
    sName = TextEditingController()..text = widget.subjectName;
    desc = TextEditingController()..text = widget.description;
    startDate = widget.sDate;
    endDate = widget.eDate;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.subjectName + " " + widget.accessCode),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Subject Name: ',
                  labelStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      fontFamily: 'Poppins'),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900], width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900], width: 2.5),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
                controller: sName,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Description: ',
                  labelStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      fontFamily: 'Poppins'),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900], width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900], width: 2.5),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
                controller: desc,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Start: ',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
                //SizedBox(width: 0.1),
                Column(
                  children: [
                    Container(
                      height: 41,
                      child: MaterialButton(
                        color: Colors.blue,
                        onPressed: () async {
                          await _startDate(context).then((value) {
                            if (endDate == null ||
                                (endDate != null && value.isBefore(endDate))) {
                              setState(() {
                                startDate = value.add(Duration(
                                    hours: startDate != null ? startDate.hour : 0,
                                    minutes: startDate != null
                                        ? startDate.minute
                                        : 0));
                              });
                            } else if (endDate != null) {
                              setState(() {
                                startDate = endDate;
                              });
                            }
                          });
                          if (startDate != null) {
                            await _selectTime(context).then((value) {
                              if (value != null) {
                                var newDate = startDate.add(Duration(
                                    hours: value.hour - startDate.hour,
                                    minutes: value.minute - startDate.minute));
                                if (endDate != null &&
                                    newDate.isBefore(endDate)) {
                                  setState(() {
                                    startDate = newDate;
                                  });
                                } else if (endDate == null) {
                                  setState(() {
                                    startDate = newDate;
                                  });
                                } else {
                                  setState(() {
                                    startDate = endDate;
                                  });
                                }
                              }
                            });
                          }
                        },
                        child: Text(
                            startDate != null
                                ? DateFormat('d MMM y on h:mm a')
                                .format(startDate)
                                : 'Select Date & Time',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white)),
                      ),
                    ),
                    startDateError
                        ? Text(
                      "*Start Time is Required",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.red,
                          fontSize: 15),
                    )
                        : Container(),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('End:',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
                SizedBox(width: 22),
                Column(
                  children: [
                    Container(
                      height: 41,
                      child: MaterialButton(
                        color: Colors.blue,
                        onPressed: () async {
                          await _endDate(context).then((value) {
                            if (startDate == null ||
                                (startDate != null && value.isAfter(startDate))) {
                              setState(() {
                                endDate = value.add(Duration(
                                    hours: endDate != null ? endDate.hour : 0,
                                    minutes:
                                    endDate != null ? endDate.minute : 0));
                              });
                            } else if (startDate != null) {
                              setState(() {
                                endDate = startDate;
                              });
                            }
                          });
                          if (endDate != null) {
                            await _selectTime(context).then((value) {
                              if (value != null) {
                                var newDate = endDate.add(Duration(
                                    hours: value.hour - endDate.hour,
                                    minutes: value.minute - endDate.minute));
                                if (startDate != null &&
                                    newDate.isAfter(startDate)) {
                                  setState(() {
                                    endDate = newDate;
                                  });
                                } else if (startDate == null) {
                                  setState(() {
                                    endDate = newDate;
                                  });
                                } else {
                                  endDate = startDate;
                                }
                              }
                            });
                          }
                        },
                        child: Text(
                            endDate != null
                                ? DateFormat('d MMM y on h:mm a').format(endDate)
                                : 'Select Date & Time',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white)),
                      ),
                    ),
                    endDateError
                        ? Text(
                      "*End Time is Required",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.red,
                          fontSize: 15),
                    )
                        : Container(),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40,),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreviewQuiz(
                                accessCode: widget.accessCode,
                                subjectName: widget.subjectName,
                                questionCount: widget.questionCount,
                                maximumScore: widget.maximumScore)),
                      );
                    },
                    child: Text("Edit Quiz ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15
                      ),),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.orange, borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: MaterialButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('Quiz')
                          .doc(widget.accessCode)
                          .update({
                        "Description": desc.text,
                        "SubjectName": sName.text,
                        "startDate": startDate,
                        "endDate": endDate,
                      });
                      Navigator.pop(
                        context,
                      );
                    },
                    child: Text("Update Quiz Description",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15
                    ),),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
