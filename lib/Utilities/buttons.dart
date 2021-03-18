import 'package:flutter/material.dart';
Widget roundedButton({BuildContext context,String text,Function onPressed,Color color}){
  return Container(
    padding: const EdgeInsets.only(left: 10,right: 10),
    alignment: Alignment.center,
    child: Container(
      width: MediaQuery.of(context).size.width*0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: color
      ),
      child: FlatButton(
        textColor: Colors.white,
        padding: EdgeInsets.all(10.0),
        splashColor: Colors.blueAccent,
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    ),
  );
}