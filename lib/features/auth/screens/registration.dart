// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/pick_image.dart';
import '../controller/auth_controller.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  File? image;
  String? name;

  //for selecting profile image
  void pickImage() async {
    image = await selectImage(context);
    setState(() {});
  }

  //store user data to db
  void storeUserData() {
    ref
        .read(authControllerProvider.notifier)
        .saveUserDataToFirestore(context, name!, image);
    if (name != null) {
      ref
          .read(authControllerProvider.notifier)
          .saveUserDataToFirestore(context, name!, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 35.0),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Informations',
                    style: TextStyle(
                      fontSize: 28.0,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'Personnelles',
                    style: TextStyle(
                      fontSize: 28,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Vous n\'êtes pas obligées de tout partager,\nseulement si vous le souhaitez. 😊',
                    style: TextStyle(
                      color: Colors.black87,
                      letterSpacing: 1.1,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Image de profil',
                            style: TextStyle(
                              color: Colors.black38,
                              letterSpacing: 0.6,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            child: image == null
                                ? Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.pink.shade300,
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundImage: FileImage(image!),
                                    radius: 60,
                                  ),
                          ),
                        ],
                      ),
                      CustomButton(
                          onPressed: () => pickImage(), text: 'Télécharger')
                    ],
                  ),
                  SizedBox(
                    height: 80.0,
                  ),
                  Text(
                    'Comment peut-on vous appeler?',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'ea. Melissa',
                      hintStyle: TextStyle(
                        color: Colors.black38,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: storeUserData,
                    child: Container(
                      color: Colors.red.shade100,
                      alignment: Alignment(0, 0.9),
                      child: Icon(
                        Icons.arrow_right_alt_sharp,
                        size: 45.0,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
