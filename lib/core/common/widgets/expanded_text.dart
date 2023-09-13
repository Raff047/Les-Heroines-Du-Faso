import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLength;

  ExpandableText({required this.text, required this.maxLength});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: _isExpanded
            ? widget.text
            : widget.text.substring(0, widget.maxLength),
        style: const TextStyle(
          fontSize: 14.0,
        ),
        children: <TextSpan>[
          _isExpanded
              ? TextSpan(
                  text: ' Voir Moins',
                  style: TextStyle(
                    color: Colors.green.shade300,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(() {
                        _isExpanded = false;
                      });
                    },
                )
              : widget.text.length > widget.maxLength
                  ? TextSpan(
                      text: '... Voir Plus',
                      style: TextStyle(
                        color: Colors.green.shade300,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            _isExpanded = true;
                          });
                        },
                    )
                  : const TextSpan(),
        ],
      ),
    );
  }
}
