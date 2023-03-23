import 'package:flutter/material.dart';

class ProfileSettingsTile extends StatelessWidget {
  const ProfileSettingsTile({
    super.key,
    required this.icon,
    required this.setting,
    required this.color,
  });

  final IconData icon;
  final String setting;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            setting,
            style: const TextStyle(fontSize: 14.0),
          )
        ],
      ),
    );
  }
}
