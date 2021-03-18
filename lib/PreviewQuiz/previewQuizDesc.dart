import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:quiz_app/PreviewQuiz/previewQuiz.dart';

class ViewQuizDesc extends StatefulWidget {
  @override
  _ViewQuizDescState createState() => _ViewQuizDescState();
}

class _ViewQuizDescState extends State<ViewQuizDesc> {
  final userId = FirebaseAuth.instance.currentUser.uid;
  var firestoreDB = FirebaseFirestore.instance
      .collection('Quiz')
      //.where("startDate",isLessThan: new DateTime.now())
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Preview Quiz"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: firestoreDB,
                  builder: (ctx, opSnapshot) {
                    if (opSnapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    final reqDocs = opSnapshot.data.documents;
                    print('length ${reqDocs.length}');
                    return ListView.builder(
                      itemCount: reqDocs.length,
                      itemBuilder: (ctx, index) {
                        if (reqDocs[index]
                            .get('Creator')
                            .toString()
                            .contains(userId))
                          return ViewDetails(reqDocs[index]);
                        return Container(
                          height: 0,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

class ViewDetails extends StatefulWidget {
  final dynamic reqDoc;

  ViewDetails(this.reqDoc);

  @override
  _ViewDetailsState createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  @override
  Widget build(BuildContext context) {
    String message;
    final questionCount = widget.reqDoc.get("QuestionCount");
    final accessCode = widget.reqDoc.get("AccessCode");
    final subjectName = widget.reqDoc.get("SubjectName");
    final maxScore = widget.reqDoc.get("MaxScore");
    final startDate =
        (widget.reqDoc.get("startDate") as Timestamp).toDate().toString();
    final endDate =
        (widget.reqDoc.get("endDate") as Timestamp).toDate().toString();

    message =
        "Subject Name: $subjectName \n Question Count: $questionCount \n Max Score: $maxScore  \n\n Start Time: $startDate \n End Date: $endDate \n\n Access Code: $accessCode";

    return Container(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        child: Card(
          elevation: 5,
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Question Count:',
                      // style: darkSmallTextBold,
                    ),
                    Text(
                      '$questionCount',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Access Code:',
                      // style: darkSmallTextBold,
                    ),
                    Text(
                      '$accessCode',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Subject Name:',
                      // style: darkSmallTextBold,
                    ),
                    Text(
                      '$subjectName',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'MaxScore:',
                      // style: darkSmallTextBold,
                    ),
                    Text(
                      '$maxScore',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Start Date:',
                      // style: darkSmallTextBold,
                    ),
                    Text(
                      '$startDate',
                    ),
                  ],
                ),
                ElevatedButton(
                  child: Text('Share Quiz'),
                  onPressed: () async {
                    var response =
                        await FlutterShareMe().shareToSystem(msg: message);
                    if (response == 'success') {
                      print('navigate success');
                    }
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreviewQuiz(
                                accessCode: accessCode,
                                subjectName: subjectName,
                                questionCount: questionCount,
                                maximumScore: maxScore)),
                      );
                    },
                    child: Text("Edit Quiz"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
