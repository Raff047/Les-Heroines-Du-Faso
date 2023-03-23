import 'package:flutter/material.dart';

class IntensityCard extends StatefulWidget {
  final String intensityText;
  final List<IconData> intensityIcons;
  const IntensityCard(
      {super.key, required this.intensityText, required this.intensityIcons});

  @override
  State<IntensityCard> createState() => _IntensityCardState();
}

class _IntensityCardState extends State<IntensityCard> {
  int _intensity = -1;
  int index = 0;

  void handleIndexFunction(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleIndexFunction(
          widget.intensityIcons.indexOf(widget.intensityIcons[index])),
      child: Container(
        decoration: BoxDecoration(
          color:
              _intensity == index ? Colors.pink.shade300 : Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        width: 80,
        height: 80,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // card icon
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  widget.intensityIcons.map((icon) => Icon(icon)).toList(),
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
          Text(
            //card title
            widget.intensityText,
            style: TextStyle(
                fontSize: 18.0,
                color: _intensity == index ? Colors.white : Colors.black45),
          ),
        ]),
      ),
    );
  }
}
