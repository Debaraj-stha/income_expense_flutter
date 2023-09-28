import 'package:flutter/material.dart';
import 'package:income/model/constraints.dart';
import 'package:income/utils/smallText.dart';

Widget buildIncomeExpenseProgress(String data, Color color, String title,
    double value, BuildContext context) {
  print(value);
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [SmallText(text: title), SmallText(text: "Rs " " $data")],
        ),
        Row(
          children: [
            SizedBox(
              width: constraints().getWidth(context) * 0.75,
              child: LinearProgressIndicator(
                color: Colors.grey[100],
                value: value / 100,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            SmallText(text: "${value.toStringAsFixed(2)}%"),
          ],
        ),
      ],
    ),
  );
}
