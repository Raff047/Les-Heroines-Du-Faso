import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TextToSpeech extends StatelessWidget {
  final String text;
  TextToSpeech({Key? key, required this.text}) : super(key: key);

  final FlutterTts tts = FlutterTts();

  Future<void> speak(text) async {
    await tts.setLanguage('fr-FR');
    await tts.setPitch(1);
    await tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => speak(text),
      child: Icon(
        MdiIcons.volumeHigh,
        size: 32,
        color: Colors.pink.shade300,
      ),
    );
  }
}
