import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset(
      "assets/images/logo.jpg",
      height: 50,
    ),
  );
}

showAlertDialog(BuildContext context, String text) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 5), child: Text(text)),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    labelText: hintText,
    labelStyle: TextStyle(
      color: Colors.white54,
    ),
    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
  );
}

TextStyle simpleTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 18,
  );
}

TextStyle mediumTextStyle() {
  return TextStyle(
    color: Colors.white70,
    fontSize: 17,
  );
}
