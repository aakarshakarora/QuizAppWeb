import 'package:flutter/material.dart';
import 'package:quiz_app/Login/userLogin.dart';

import '../Register/F_Register/registerFaculty.dart';
import '../Register/S_Register/registerStudent.dart';



class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isMenuOpen = false;
  String text = 'Sign Up';
  Size buttonSize;
  GlobalKey _key = LabeledGlobalKey("button_icon");
  Offset buttonPosition;
  OverlayEntry _overlayEntry;
  List<Text> type = [
    Text(
        'Student',
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins'
        )
    ),
    Text(
      'Teacher',
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins'
      ),
    ),
  ];

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: buttonPosition.dx,
          width: buttonSize.width,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ClipPath(
                    clipper: ArrowClipper(),
                    child: Container(
                      width: 17,
                      height: 17,
                      color: Colors.orange,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        type.length,
                            (index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                text = 'Sign Up';
                              });
                              print(index);
                              switch (index) {
                                case 0:
                                  print('selected 0');

                                  closeMenu();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => StudentRegister(),
                                    ),
                                  );
                                  break;
                                case 1:
                                  print('selected 1');
                                  closeMenu();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => FacultyRegister(),
                                    ),
                                  );
                                  break;

                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: buttonSize.width,
                              height: buttonSize.height,
                              child: type[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  findButton() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void openMenu() {
    findButton();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry);
    isMenuOpen = !isMenuOpen;
  }

  void closeMenu() {
    _overlayEntry.remove();
    isMenuOpen = !isMenuOpen;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                if (isMenuOpen) closeMenu();
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
            Container(
              key: _key,
              child: MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () {
                  if (isMenuOpen) {
                    setState(() {
                      text = 'Sign Up';
                    });
                    closeMenu();
                  } else {
                    setState(() {
                      text = 'Sign Up As...';
                    });
                    openMenu();
                  }
                },
                child: Text(
                  text,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}