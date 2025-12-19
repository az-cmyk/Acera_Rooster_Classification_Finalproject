import 'package:flutter/material.dart';

class RoosterLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const RoosterLogo({
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/rooster_logo.png',
      width: size,
      height: size,
      color: color,
    );
  }
}
