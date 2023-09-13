import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {super.key,
      required this.hintText,
      this.onChanged,
      required this.controller,
      required this.onEditingComplete,
      required this.readOnly,
      this.prefixText});

  final String hintText;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final TextEditingController controller;
  final bool readOnly;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: onEditingComplete,
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
        prefixText: prefixText,
        suffixIcon: const Icon(MdiIcons.pencil),
        hintText: hintText,
        fillColor: const Color(0xff4c4f64),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
