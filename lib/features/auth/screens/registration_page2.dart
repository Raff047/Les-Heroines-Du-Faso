// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'widgets/intensity_card.dart';

class RegistrationPage2 extends StatefulWidget {
  RegistrationPage2({Key? key}) : super(key: key);

  @override
  State<RegistrationPage2> createState() => _RegistrationPage2State();
}

class _RegistrationPage2State extends State<RegistrationPage2> {
  int _isSelected = -1;
  int _intensity = -1;

  @override
  Widget build(BuildContext context) {
    List<String> intensityValues = ['Low', 'Normal', 'Medium', 'High'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Questions',
          style: TextStyle(
            fontSize: 28.0,
            letterSpacing: 1.2,
          ),
        ),
        Text(
          'liées à votre cycle',
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
          'Ces questions aident à vous donner\nde meilleures prédictions. Vous pouvez les modifier ultérieurement.',
          style: TextStyle(
            color: Colors.black87,
            letterSpacing: 1.1,
            height: 1.4,
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
        Text(
          'Habituellement, combien de jours dure votre cycle?',
          style: TextStyle(
            color: Colors.black38,
            letterSpacing: 0.6,
          ),
        ),
        SizedBox(
          height: 25.0,
        ),
        Container(
            height: 60,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 9,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSelected = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isSelected == index
                            ? Colors.pink.shade300
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: 60,
                      height: 60,
                      child: Center(
                          child: Text(
                        "${index + 1}",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: _isSelected == index
                                ? Colors.white
                                : Colors.black45),
                      )),
                    ),
                  );
                }))),
        SizedBox(
          height: 50.0,
        ),
        Text(
          'Quelle est l\'intensité de votre cycle?',
          style: TextStyle(
            color: Colors.black38,
            letterSpacing: 0.6,
          ),
        ),
        SizedBox(
          height: 25.0,
        ),
        Container(
            height: 60,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: ((context, index) {
                  List<IconData> intensityIcons = List.generate(
                      index + 1, (int i) => Icons.water_drop_outlined);
                  List<String> intensityValues = [
                    'Low',
                    'Normal',
                    'Medium',
                    'High'
                  ];
                  return IntensityCard(
                    intensityText: intensityValues[index],
                    intensityIcons: intensityIcons,
                  );
                }))),
      ],
    );
  }
}
