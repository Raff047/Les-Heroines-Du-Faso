import 'package:flutter/material.dart';

class CommunityCard extends StatelessWidget {
  const CommunityCard({
    super.key,
    required this.screenHeight,
    required this.name,
    required this.description,
    required this.banner,
    required this.onTap,
    required this.isSelected,
  });

  final double screenHeight;
  final String name;
  final String description;
  final String banner;
  final Function()? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        height: screenHeight * 0.3,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(banner),
            fit: BoxFit.cover,
            opacity: 0.9,
            colorFilter:
                const ColorFilter.mode(Colors.black26, BlendMode.darken),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: const TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
