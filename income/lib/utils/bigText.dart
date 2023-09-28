import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  const BigText(
      {super.key,
      required this.text,
      this.color = Colors.black,
      this.size = 25,
      this.family = 'Roboto',
      this.weight = FontWeight.w600});
  final String text;
  final Color color;
  final double size;
  final String family;
  final FontWeight weight;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: color, fontSize: size, fontWeight: weight, fontFamily: family),
    );
  }
}
