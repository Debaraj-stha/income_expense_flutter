import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  const SmallText(
      {super.key,
      required this.text,
      this.color = Colors.black,
      this.size = 18,
      this.family = "Roboto",
      this.textAlign = TextAlign.start,
      this.weight = FontWeight.w600});
  final String text;
  final Color color;
  final double size;
  final String family;
  final FontWeight weight;
  final TextAlign textAlign;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color, fontSize: size, fontWeight: weight, fontFamily: family),
    );
  }
}
