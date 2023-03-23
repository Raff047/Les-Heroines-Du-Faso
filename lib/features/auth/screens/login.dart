// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/theme/pallete.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/loader.dart';
import '../../../core/common/widgets/show_snack_bar.dart';
import '../smart_auth_wrapper.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  String? email;
  String? password;
  Country selectedCountry = Country(
      phoneCode: '1',
      countryCode: 'CA',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'Canada',
      example: 'Canada',
      displayName: 'Canada',
      displayNameNoCountryCode: 'CA',
      e164Key: "");

  // method to sendPhoneNumber to firebase VerifyWithPhone method
  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (selectedCountry != null && phoneNumber.isNotEmpty) {
      ref.read(authControllerProvider.notifier).signInWithPhoneNumber(
          context: context,
          phoneNumber: "+${selectedCountry.phoneCode}$phoneNumber");
    } else {
      showSnackBar(context: context, content: 'Svp! Remplir tous les champs');
    }
  }

  void sendEmailAndPassword() async {
    try {
      final user = await ref
          .read(authControllerProvider.notifier)
          .signInForOthersWithEmail(context, email, password);

      user.fold((l) => showSnackBar(context: context, content: l.message),
          (user) {
        if (user != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SmartAuthWrapper()));
        }
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    //trick to fix textfield input direction
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length),
    );

    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: isLoading
          ? Loader()
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 35.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.pink.shade200,
                        ),
                        child: Image.asset(
                          'assets/images/login_img.png',
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        'Inscrivez-vous',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        'Ajoutez votre numéro de téléphone, nous vous enverrons un code de vérification.',
                        style: TextStyle(
                          fontSize: 15.0,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: phoneController,
                        onChanged: (value) {
                          setState(() {
                            phoneController.text = value;
                          });
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(22),
                          filled: true,
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                            letterSpacing: 0.7,
                          ),
                          hintText: 'Entrez votre numéro...',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Pallete.whiteColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Pallete.greenColor),
                          ),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                showCountryPicker(
                                  countryListTheme: CountryListThemeData(
                                    bottomSheetHeight: 500.0,
                                  ),
                                  context: context,
                                  onSelect: (value) {
                                    setState(() {
                                      selectedCountry = value;
                                    });
                                  },
                                );
                              },
                              child: Text(
                                "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          suffixIcon: phoneController.text.length > 9
                              ? Container(
                                  margin: EdgeInsets.all(8.0),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Pallete.greenColor,
                                  ),
                                  child: Icon(
                                    Icons.done,
                                    size: 20,
                                  ),
                                )
                              : null,
                        ),
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        cursorColor: Pallete.greenColor,
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: CustomButton(
                          onPressed: sendPhoneNumber,
                          text: 'Connexion',
                        ),
                      ),
                      // email and passwrooooooooooooooooood for personals
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'For Personal',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 25,
                      ),

                      //email textfield
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),

                      SizedBox(
                        height: 12.0,
                      ),

                      //password textfield
                      TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'password',
                        ),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      CustomButton(
                          onPressed: () => sendEmailAndPassword(),
                          text: 'connect'),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
