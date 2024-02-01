import 'package:flutter/material.dart';

import '../utlitis/constant.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.title,
    required this.controller,
    required this.obscureText,
  });

  final String title;
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: kPrimeryColor), borderRadius: BorderRadius.all(Radius.circular(10))))),
      ],
    );
  }
}
