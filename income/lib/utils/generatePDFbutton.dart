import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/utils/smallText.dart';

import '../model/controller.dart';

class GeneratePDF extends StatelessWidget {
  GeneratePDF(
      {super.key,
      required this.total,
      required this.title,
      required this.isDate,
      this.currency = "RS",
      this.data});
  myController controller = Get.find();
  final double total;
  final bool isDate;
  final String title;
  final String currency;
  final data;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          controller.generatePDF(data, isDate, title, total, currency);
        },
        child: SmallText(
          text: "Download the file",
          color: constraints.secondaryColor,
        ));
  }
}
