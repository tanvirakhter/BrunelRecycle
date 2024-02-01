import 'package:flutter/material.dart';

import '../utlitis/constant.dart';

void showSnackBar(BuildContext context, String text, [String buttonText = '']) {
  final snackBar = SnackBar(
    content: Text(text),
    backgroundColor: kSecondaryColor,
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: buttonText,
      disabledTextColor: Colors.white,
      textColor: Colors.yellow,
      onPressed: () {
        //Do whatever you want
      },
    ),
    onVisible: () {
      //your code goes here
    },
    duration: Duration(milliseconds: 500),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
