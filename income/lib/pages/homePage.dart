import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/model/controller.dart';
import 'package:income/pages/searchDataPage.dart';
import 'package:income/pages/yesterdayIncome.dart';

import 'package:income/utils/appBar.dart';

import 'package:income/utils/expense.dart';
import 'package:income/utils/income.dart';
import 'package:income/utils/incomeExpenseChart.dart';
import 'package:income/utils/smallText.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  FocusNode focusNode = FocusNode();
  myController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SmallText(text: "Homepage"),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  onTapOutside: (event) {
                    if (focusNode.hasFocus) {
                      focusNode.unfocus();
                    }
                  },
                  onFieldSubmitted: (value) {
                    List<String> split = value.split(" ");
                    String type = "income";
                    late int index = 0;
                    if (split.contains("expense")) {
                      index = split.indexOf('expense');
                      type = "expense";
                    }
                    String title =
                        index >= 1 ? split[index - 1] : split[index + 1];
                    controller.searchSpecificData(value);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchDataPage(title: title, type: type)));
                  },
                  cursorColor: constraints.primaryColor,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(6),
                      border: InputBorder.none,
                      helperText: "Search here by date,specific,category name",
                      helperStyle: TextStyle(fontSize: 15),
                      hintText: "Search here..."),
                ),
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Income(), // Wrap in Obx if Income depends on myController.
              const Expense(), // Wrap in Obx if Expense depends on myController.
              const IncomeExpenseChart(),
              TextButton(
                  onPressed: () {
                    controller.fetchYesterdayData('income', 1);
                    Future.delayed(const Duration(milliseconds: 500), () {
                      return Navigator.push(
                          context,
                          PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              reverseTransitionDuration:
                                  const Duration(milliseconds: 500),
                              pageBuilder:
                                  ((context, animation, secondaryAnimation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: const YesterDayIncome(),
                                );
                              })));
                    });
                  },
                  child: SmallText(
                    text: "View this yesterday data",
                    color: constraints.secondaryColor,
                  )),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () {},
                  child: SmallText(
                    text: "View this month data",
                    color: constraints.secondaryColor,
                  )),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () {},
                  child: SmallText(
                    text: "View this year data",
                    color: constraints.secondaryColor,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
