import 'package:flutter/material.dart';
import 'package:health_app/theme/pallete.dart';

class NoConversations extends StatelessWidget {
  const NoConversations({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.messenger_rounded,
            size: 55,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Pas de conversations',
            style: TextStyle(
              fontSize: 30,
            ),
          )
        ],
      ),
    );
  }
}
