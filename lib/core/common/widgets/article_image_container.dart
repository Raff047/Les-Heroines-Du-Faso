// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ArticleImageContainer extends StatelessWidget {
  const ArticleImageContainer({
    Key? key,
    required this.width,
    this.height = 300.0,
    required this.imageUrl,
    this.padding,
    this.margin,
    this.borderRadius,
    this.boxShadow,
    this.child,
    this.colorFilter,
  }) : super(key: key);

  final double width;
  final double height;
  final String imageUrl;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Widget? child;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color(0xffffafbd),
              Color(0xffffc3a0),
            ]),
        image: DecorationImage(
          colorFilter: colorFilter,
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
