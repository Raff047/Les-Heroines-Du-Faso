// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/theme/pallete.dart';
import 'package:pinput/pinput.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/loader.dart';
import '../../../core/common/widgets/show_snack_bar.dart';
import '../controller/auth_controller.dart';

class OtpScreen extends ConsumerStatefulWidget {
  //the verificationId that firebase sends to our app
  final String verificationId;

  const OtpScreen({super.key, required this.verificationId});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  String? otpCode;

  void verifyOTP(BuildContext context, String verificationId, String userOTP,
      WidgetRef ref) {
    ref.read(authControllerProvider.notifier).verifyOTP(
          context,
          verificationId,
          otpCode!,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: isLoading
          ? Loader()
          : SafeArea(
              child: isLoading
                  ? Loader()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 35.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                child: Icon(Icons.arrow_back_ios),
                                onTap: () => Navigator.of(context).pop(),
                              ),
                            ),
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
                              'Verification',
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
                              'Entrez le code envoyé à votre numero.',
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
                            Pinput(
                              length: 6,
                              showCursor: true,
                              defaultPinTheme: PinTheme(
                                textStyle: TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                                width: 56.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Colors.white),
                                ),
                              ),
                              onCompleted: (value) {
                                setState(() {
                                  otpCode = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50.0,
                              child: CustomButton(
                                  onPressed: () {
                                    if (otpCode != null) {
                                      verifyOTP(context, widget.verificationId,
                                          otpCode!, ref);
                                    } else {
                                      showSnackBar(
                                          context: context,
                                          content:
                                              'code doit etre a 6 chiffres');
                                    }
                                  },
                                  text: 'Verifier'),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Text(
                              'Aucun code reçu ?',
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
                            Text(
                              'Renvoyer un nouveau code',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Pallete.greenColor,
                                letterSpacing: 1.3,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
    );
  }
}
