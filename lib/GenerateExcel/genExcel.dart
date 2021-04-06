import 'dart:convert';
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Alignment;

/// Represents the XlsIO stateful widget class.
class CreateExcel extends StatefulWidget {
  @override
  _CreateExcelState createState() => _CreateExcelState();
}

class _CreateExcelState extends State<CreateExcel> {
  int count = 2;
  String accessCode;
  final accessCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generate Excel"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  labelText: 'Enter Access Code:',
                  labelStyle: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Poppins',
                  )),
              keyboardType: TextInputType.text,
              controller: accessCodeController,
            ),
            MaterialButton(
              child: const Text(
                'Download Responses',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () async {
                setState(() {
                  accessCode = accessCodeController.text + 'Result';
                });
                generateExcel(accessCode);
              },
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateExcel(String accessCode) async {
    print("Function Called");
    //Create a Excel document.

    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = true;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    //Set data in the worksheet.

    sheet.getRangeByName('A1').setText('Name');
    sheet.getRangeByName('B1').setText('ID');
    sheet.getRangeByName('C1').setText('Email ID');
    sheet.getRangeByName('D1').setText('Score');
    sheet.getRangeByName('E1').setText('Tab Switch');
    sheet.getRangeByName('F1').setText('Logged In');
    sheet.getRangeByName('G1').setText('User ID');
    sheet.getRangeByName('H1').setText('Max Score');
    String subjectName;
    String code;
    code = accessCode.substring(0, 5);

    final cloud = await FirebaseFirestore.instance
        .collection('Quiz')
        .doc(code)
        .collection(accessCode)
        .get();

    print("Code is: $accessCode");

    for (var document in cloud.docs) {
      sheet
          .getRangeByName('A' + count.toString())
          .setText(document.data()['S_Name'].toString());
      sheet
          .getRangeByName('B' + count.toString())
          .setText(document.data()['S_RegNo'].toString());
      sheet
          .getRangeByName('C' + count.toString())
          .setText(document.data()['S_EmailID'].toString());
      sheet
          .getRangeByName('D' + count.toString())
          .setText(document.data()['Score'].toString());
      sheet
          .getRangeByName('E' + count.toString())
          .setText(document.data()['tabSwitch'].toString());
      sheet
          .getRangeByName('F' + count.toString())
          .setText(document.data()['attempted'].toString());
      sheet
          .getRangeByName('G' + count.toString())
          .setText(document.data()['S_UID'].toString());
      sheet
          .getRangeByName('H' + count.toString())
          .setText(document.data()['maxScore'].toString());

      count++;
    }

    await FirebaseFirestore.instance
        .collection('Quiz')
        .doc(code)
        .get()
        .then((value) {
      subjectName = value.data()['SubjectName'];
    });

    sheet.getRangeByName('A1:E1').cellStyle.backColor = '#FFFF00';
    sheet.getRangeByName('A1:E1').cellStyle.bold = true;

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "$subjectName $code.xlsx")
      ..click();

    print("Code is: $accessCode");
    print("Result is: $code");
  }
}
