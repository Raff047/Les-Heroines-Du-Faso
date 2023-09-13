import 'package:flutter/material.dart';

class IntroScreen1 extends StatelessWidget {
  const IntroScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container()),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Communauté Femmes',
              style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Connectez-vous avec d\'autres femmes pour discuter de tout ce qui concerne votre santé sexuelle.',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
            ),
          ),
          const SizedBox(
            height: 120,
          ),
          Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            height: 340,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/onboarding-community.png'),
                    fit: BoxFit.cover)),
          ),
        ],
      ),
    );
  }
}
