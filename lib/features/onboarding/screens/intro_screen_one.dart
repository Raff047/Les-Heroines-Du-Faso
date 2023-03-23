// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class IntroScreenOne extends StatelessWidget {
  const IntroScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 35.0),
            child: Column(
              children: [
                Container(
                  width: 280,
                  height: 280,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/welcome_img.png',
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  'Bienvenue',
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
                  'Les Héroines du Faso, votre platforme de confiance pour la santé sexuelle et mentale.',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black38,
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
