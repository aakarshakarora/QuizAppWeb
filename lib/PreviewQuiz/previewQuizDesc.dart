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
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text(widget.subjectName + " " + widget.accessCode),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                prefixText: 'Subject Name: ',
                prefixStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            controller: sName,
          ),
          TextField(
            decoration: InputDecoration(
                prefixText: 'Description: ',
                prefixStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            controller: desc,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Start:',
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
                    child: TextButton(
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
                              fontWeight: FontWeight.w300,
                              fontSize: 17,
                              color: Colors.black)),
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
          SizedBox(width: 30),
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
                    child: TextButton(
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
                              fontWeight: FontWeight.w300,
                              fontSize: 17,
                              color: Colors.black)),
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
          Row(
            children: [
              FlatButton(
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
                child: Text("Edit Quiz "),
              ),
              SizedBox(
                width: 10,
              ),
              FlatButton(
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
                child: Text("Update Quiz Description"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
