import 'package:flutter/material.dart';
import 'package:health_app/theme/pallete.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, required this.text});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Pallete.greenColor),
        backgroundColor: MaterialStateProperty.all<Color>(Pallete.greenColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );
  }
}
