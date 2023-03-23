// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileAppBar extends ConsumerWidget {
  const ProfileAppBar({
    super.key,
    required this.photoURL,
    required this.startColor,
    required this.endColor,
    required this.name,
    required this.basedIn,
  });
  final String photoURL;
  final Color startColor;
  final Color endColor;
  final String name;
  final String basedIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: CustomPaint(
          painter: LogoPainter(startColor, endColor),
          size: const Size(400, 195),
          child: _appBarContent(photoURL, name, basedIn)),
    );
  }
}

class LogoPainter extends CustomPainter {
  final Color startColor;
  final Color endColor;

  LogoPainter(this.startColor, this.endColor);
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    Paint paint = Paint();
    Path path = Path();
    paint.shader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        // Color.fromARGB(255, 242, 101, 197),
        // Color.fromARGB(255, 154, 76, 237),

        startColor,
        endColor,
      ],
    ).createShader(rect);
    path.lineTo(0, size.height - size.height / 8);
    path.conicTo(size.width / 1.2, size.height, size.width,
        size.height - size.height / 8, 9);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Widget _appBarContent(String photoURL, String name, String basedIn) {
  return Container(
    height: 195,
    width: 400,
    margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
    child: Column(
      children: [
        _header(),
        const SizedBox(
          height: 20,
        ),
        _userInfo(photoURL, name, basedIn)
      ],
    ),
  );
}

Widget _header() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: const [
      Icon(
        Icons.arrow_back_ios_new_sharp,
        color: Colors.white,
        size: 30,
      ),
    ],
  );
}

Widget _userInfo(String photURL, String name, String basedIn) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _userAvatar(photURL),
      const SizedBox(
        width: 20,
      ),
      Expanded(
        flex: 1,
        child: Column(
          children: [
            _userPersonalInfo(name, basedIn),
            const SizedBox(
              height: 25,
            ),
            _userArticlefo()
          ],
        ),
      )
    ],
  );
}

Widget _userPersonalInfo(String name, String basedIn) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 28, color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            basedIn,
            style: const TextStyle(
                fontSize: 12, letterSpacing: 2, color: Colors.white),
          )
        ],
      ),
    ],
  );
}

Widget _userArticlefo() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            '10',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Articles',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11),
          ),
        ],
      ),
    ],
  );
}

Widget _userAvatar(String photoURL) {
  return CircleAvatar(radius: 35, backgroundImage: NetworkImage(photoURL));
}
