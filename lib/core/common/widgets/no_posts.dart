import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoPosts extends StatelessWidget {
  const NoPosts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/no_posts.svg',
          height: 200,
          width: 200,
        ),
        const Text(
          'Cette communauté est vide. Soyez le premier à poster!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white60),
        ),
      ],
    );
  }
}
