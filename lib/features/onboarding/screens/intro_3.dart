import 'package:flutter/material.dart';

class IntroScreen3 extends StatelessWidget {
  const IntroScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 146, 76)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container()),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Articles Experts',
              style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Élargissez vos connaissance grâce à nos articles de spécialistes pour une santé sexuelle épanouissante et un bien-être optimal.',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            height: 420,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/onboarding-article.png'),
                    fit: BoxFit.cover)),
          ),
        ],
      ),
    );
  }
}
