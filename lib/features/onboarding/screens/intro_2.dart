import 'package:flutter/material.dart';

class IntroScreen2 extends StatelessWidget {
  const IntroScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xffEEBAA2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container()),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Live Chat',
              style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Parlez à nos spécialistes de la santé en temps réel pour des conseils personnalisés et confidentiels.',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
            ),
          ),
          const SizedBox(height: 120),
          Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            height: 340,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    colorFilter:
                        ColorFilter.mode(Color(0xffEEBAA2), BlendMode.darken),
                    image: AssetImage('assets/images/chat.jpg'),
                    fit: BoxFit.cover)),
          ),
        ],
      ),
    );
  }
}
