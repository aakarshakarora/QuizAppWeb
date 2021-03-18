import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:quiz_app/Utilities/buttons.dart';

class PreviewQuiz extends StatefulWidget {
  final String subjectName, accessCode;
  final int questionCount, maximumScore;

  PreviewQuiz({
    @required this.accessCode,
    @required this.subjectName,
    @required this.questionCount,
    @required this.maximumScore,
  });

  @override
  _PreviewQuizState createState() => _PreviewQuizState();
}

class _PreviewQuizState extends State<PreviewQuiz> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uId, subjectName, creatorName, maxScore, quizDate;

  String getUserID() {
    final User user = _auth.currentUser;
    final uid = user.uid;
    print(uid);
    return uid.toString();
  }

  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var firestoreDB = FirebaseFirestore.instance
        .collection('Quiz')
        .doc(widget.accessCode)
        .collection(widget.accessCode)
        .snapshots();
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text(widget.subjectName),
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
                  final reqDocs = opSnapshot.data.documents..shuffle();
                  print('length ${reqDocs.length}');
                  return PageView.builder(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reqDocs.length,
                    itemBuilder: (ctx, index) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: (BorderRadius.circular(20)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PreviewQuestionTile(
                              index: index,
                              reqDoc: reqDocs[index],
                              correctAnswerMarks:
                                  (widget.maximumScore) / (reqDocs.length),
                              code: widget.accessCode,
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                index == 0
                                    ? Container()
                                    : roundedButton(
                                        color: Colors.blue,
                                        context: context,
                                        text: "Prev",
                                        onPressed: () {
                                          print("Prev Button is pressed!");
                                          print(index);
                                          print(widget.questionCount);
                                          pageController.animateToPage(
                                              index - 1,
                                              duration:
                                                  Duration(milliseconds: 200),
                                              curve: Curves.easeIn);
                                        }),
                                index != widget.questionCount - 1
                                    ? roundedButton(
                                        color: Colors.blue,
                                        context: context,
                                        text: "Next",
                                        onPressed: () {
                                          print("Next Button is pressed!");
                                          print(index);
                                          print(widget.questionCount);

                                          pageController.animateToPage(
                                              index + 1,
                                              duration:
                                                  Duration(milliseconds: 200),
                                              curve: Curves.bounceInOut);
                                        })
                                    : Container(),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PreviewQuestionTile extends StatefulWidget {
  // TODO:defined totalDocs
  final dynamic reqDoc, index, correctAnswerMarks, code;

  PreviewQuestionTile(
      {@required this.reqDoc,
      @required this.index,
      @required this.correctAnswerMarks,
      @required this.code});

  @override
  _PreviewQuestionTileState createState() => _PreviewQuestionTileState();
}

class _PreviewQuestionTileState extends State<PreviewQuestionTile>
    with AutomaticKeepAliveClientMixin {
  String selectedValue;

  String option1, option2, option3, option4, ques, docID, code;

  List<String> options = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    options = [
      widget.reqDoc.get("01"),
      widget.reqDoc.get("02"),
      widget.reqDoc.get("03"),
      widget.reqDoc.get("04"),
    ];

    option1 = widget.reqDoc.get("01");
    option2 = widget.reqDoc.get("02");
    option3 = widget.reqDoc.get("03");
    option4 = widget.reqDoc.get("04");
    ques = widget.reqDoc.get("Ques");
    print(widget.reqDoc.documentID);
    docID = widget.reqDoc.documentID;
    code = widget.code;
    options.shuffle();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Q${widget.index + 1} ${widget.reqDoc.get("Ques")}",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20
          ),),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (ctx, index) {
                return Row(
                  children: [
                    Radio(
                        value: options[index],
                        groupValue: selectedValue,
                        onChanged: (value) {}),
                    Flexible(child: Text(options[index],
                      style: TextStyle(
                          fontSize: 17
                      ),)),
                  ],
                );
              }),

          // ignore: deprecated_member_use
          Container(
            alignment: Alignment.center,
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditQuesAns(option1, option2,
                            option3, option4, ques, docID, code)),
                  );
                },
                //child: Text("Edit ")),
                icon: Icon(Icons.edit)),
          )
        ],
      ),
    );
  }
}

class EditQuesAns extends StatefulWidget {
  final String option1, option2, option3, option4, ques, docId, code;

  EditQuesAns(this.option1, this.option2, this.option3, this.option4, this.ques,
      this.docId, this.code);

  @override
  _EditQuesAnsState createState() => _EditQuesAnsState();
}

class _EditQuesAnsState extends State<EditQuesAns> {
  String option1, option2, option3, option4, ques;

  TextEditingController q, o1, o2, o3, o4;

  @override
  void initState() {
    q = TextEditingController()..text = widget.ques;
    o1 = TextEditingController()..text = widget.option1;
    o2 = TextEditingController()..text = widget.option2;
    o3 = TextEditingController()..text = widget.option3;
    o4 = TextEditingController()..text = widget.option4;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit question"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: q,
                decoration: InputDecoration(
                    prefixText: 'Question: ',
                    prefixStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              ),
              TextField(
                decoration: InputDecoration(
                    prefixText: 'Option1(Correct Answer): ',
                    prefixStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                controller: o1,
              ),
              TextField(
                decoration: InputDecoration(
                    prefixText: 'Option2: ',
                    prefixStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                controller: o2,
              ),
              TextField(
                decoration: InputDecoration(
                    prefixText: 'Option3: ',
                    prefixStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                controller: o3,
              ),
              TextField(
                decoration: InputDecoration(
                    prefixText: 'Option4: ',
                    prefixStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                controller: o4,
              ),
              SizedBox(
                height: 50,
              ),
              roundedButton(
                  color: Colors.blue,
                  context: context,
                  text: "Update",
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('Quiz')
                        .doc(widget.code)
                        .collection(widget.code)
                        .doc(widget.docId)
                        .update({
                      "01": o1.text,
                      "02": o2.text,
                      "03": o3.text,
                      "04": o4.text,
                      "Ques": q.text,
                    });
                    Navigator.pop(
                      context,
                    );
                  }),
            ],
          ),
        ));
  }
}
