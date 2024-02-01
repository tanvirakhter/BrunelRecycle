import 'package:flutter/material.dart';

import '../utlitis/constant.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.width,
    required this.text,
    required this.onPress,
    this.height: 50,
    this.btnColor: kPrimeryColor,
    this.txtFontSize: 18,
    this.txtColor: Colors.white,
    this.btnradius: 30,
  });

  final double width;
  final String text;
  final VoidCallback onPress;
  final double height;
  final double txtFontSize;
  final Color btnColor;
  final Color txtColor;
  final double btnradius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.9,
      height: height,
      decoration: BoxDecoration(color: btnColor, borderRadius: BorderRadius.all(Radius.circular(btnradius))),
      child: TextButton(
        onPressed: onPress,
        child: Text(
          text,
          style: TextStyle(color: txtColor, fontSize: txtFontSize),
        ),
      ),
    );
  }
}
