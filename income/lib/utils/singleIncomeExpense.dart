import 'package:flutter/material.dart';
import 'package:income/model/constraints.dart';
import 'package:income/utils/smallText.dart';

class SingleIncomeExpense extends StatelessWidget {
  const SingleIncomeExpense(
      {super.key,
      required this.title,
      required this.amount,
      this.color = Colors.black});
  final String title;
  final String amount;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SmallText(
            text: title,
            color: color,
          ),
          SmallText(
            text: amount,
            color: color,
          )
        ],
      ),
    );
  }
}
