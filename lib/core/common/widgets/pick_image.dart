import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health_app/core/common/widgets/show_snack_bar.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> selectImage(BuildContext context) async {
  File? image;
  try {
    final selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      image = File(selectedImage.path);
    }
  } catch (error) {
    showSnackBar(context: context, content: error.toString());
  }

  return image;
}
