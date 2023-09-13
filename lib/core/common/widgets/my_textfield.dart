// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final onChanged;
  final String hintText;
  final obsecureText;
  final IconData? icon;

  const MyTextField(
      {Key? key,
      required this.onChanged,
      required this.hintText,
      required this.obsecureText,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: obsecureText,
      decoration: InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.all(18),
        hintText: hintText,
        hintStyle: TextStyle(
          letterSpacing: 1.2,
        ),
        alignLabelWithHint: true,
        border: InputBorder.none,
      ),
    );
  }
}
