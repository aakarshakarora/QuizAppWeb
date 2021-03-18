import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/Model/resultModel.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieChartDisplay extends StatefulWidget {
  final String accessCode;

  PieChartDisplay(this.accessCode);

  @override
  _PieChartDisplayState createState() => _PieChartDisplayState();
}

class _PieChartDisplayState extends State<PieChartDisplay> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String currentUser;
  int score, inactiveState;

//Get Current User
  String getCurrentUser() {
    final User user = _auth.currentUser;
    final uid = user.uid;
    final uemail = user.email;
    print(uid);
    print(uemail);
    return uid.toString();
  }

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUser();



    FirebaseFirestore.instance
        .collection('Quiz')
        .doc(widget.accessCode)
        .collection(widget.accessCode + 'Result')
        .doc(currentUser)
        .get()
        .then((value) {
          setState(() {
            score = value.data()['Score'];
            inactiveState = value.data()['tabSwitch'];
          });
      score = value.data()['Score'];
      inactiveState = value.data()['tabSwitch'];
      print("Score: $score");
      print("Inactive: $inactiveState");
    });
  }

  List<charts.Series<ResultModel, String>> _seriesPieData;
  List<ResultModel> mydata;

  _generateData(mydata) {
    _seriesPieData = List<charts.Series<ResultModel, String>>();
    _seriesPieData.add(
      charts.Series(
        domainFn: (ResultModel task, _) => task.score.toString(),
        measureFn: (ResultModel task, _) => task.maxScore,
        // colorFn: (ResultModel task, _) =>
        //     charts.ColorUtil.fromDartColor(Color(int.parse(task.colorVal))),
        id: 'tasks',
        data: mydata,
        labelAccessorFn: (ResultModel row, _) => "${row.score}",
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Quiz')
          .doc(widget.accessCode)
          .collection(widget.accessCode + 'Result')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<ResultModel> task = snapshot.data.docs
              .map((documentSnapshot) =>
              ResultModel.fromMap(documentSnapshot.data()))
              .toList();
          return _buildChart(context, task);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<ResultModel> Resultdata) {
    mydata = Resultdata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Pie Chart',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Text("Your Score is: "+score.toString()),
              Text("Inactive State Count: " +inactiveState.toString()),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.PieChart(_seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 5),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                        charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 2,
                        cellPadding: new EdgeInsets.only(
                            right: 4.0, bottom: 4.0, top: 4.0),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 18),
                      )
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 100,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.inside)
                        ])),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pie Chart'),
      ),
      body: _buildBody(context),
    );
  }
}
