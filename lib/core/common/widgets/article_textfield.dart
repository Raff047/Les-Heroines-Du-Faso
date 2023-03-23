// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ArticleForm extends StatelessWidget {
  const ArticleForm({
    Key? key,
    required this.onChanged,
    this.maxLines,
    required this.hintText,
    this.controller,
  }) : super(key: key);

  final void Function(String) onChanged;
  final int? maxLines;
  final String hintText;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(letterSpacing: 1.4),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
