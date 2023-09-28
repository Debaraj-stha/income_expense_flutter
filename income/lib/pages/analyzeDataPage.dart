import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/pages/oneMonthExpense.dart';
import 'package:income/pages/oneMonthIncome.dart';
import 'package:income/pages/oneYearData.dart';
import 'package:income/pages/oneYearIncome.dart';
import 'package:income/pages/yearlyExpense.dart';
import 'package:income/pages/yearlyIncome.dart';
import 'package:income/utils/barChart.dart';
import 'package:income/utils/detailsExpense.dart';

import 'package:income/utils/smallText.dart';

import '../model/controller.dart';

class AnalyzeDataPage extends StatefulWidget {
  const AnalyzeDataPage({super.key});

  @override
  State<AnalyzeDataPage> createState() => _AnalyzeDataPageState();
}

class _AnalyzeDataPageState extends State<AnalyzeDataPage> {
  @override
  void initState() {
    // TODO: implement initState
    // controller.getLongIncomeExpenseData(1, 'income');

    super.initState();
  }

  myController controller = Get.find();
  List<Map<String, dynamic>> oneMonthExpenses = [
    {
      "title": "Grocery",
      "amount": "3000",
    },
    {
      "title": "Entertainment",
      "amount": "2000",
    },
    {
      "title": "Transportation",
      "amount": "1000",
    },
    {
      "title": "health",
      "amount": "1000",
    },
    {
      "title": "education",
      "amount": "1000",
    },
    {
      "title": "clothing",
      "amount": "1000",
    },
    {
      "title": "extra",
      "amount": "1000",
    }
  ];
  List<Map<String, dynamic>> yearlyExpense = [
    {"year": "2000", "amount": "100000"},
    {"year": "2001", "amount": "50333"},
    {"year": "2002", "amount": "100000"},
    {"year": "2003", "amount": "90000"},
    {"year": "2004", "amount": "100000"},
    {"year": "2005", "amount": "20000"},
    {"year": "2006", "amount": "40000"},
    {"year": "2007", "amount": "150000"}
  ];
  List<Map<String, dynamic>> monthlyExpenses = [
    {"title": "jan", "amount": "17000"},
    {"title": "feb", "amount": "12022"},
    {"title": "mar", "amount": "10000"},
    {"title": "apr", "amount": "40000"},
    {"title": "may", "amount": "4000"},
    {"title": "jun", "amount": "17000"},
    {"title": "july", "amount": "33000"},
    {"title": "aug", "amount": "6627"},
    {"title": "sep", "amount": "20000"},
    {"title": "oct", "amount": "1000"},
    {"title": "nov", "amount": "6000"},
    {"title": "dec", "amount": "45000"},
  ];

  // controller.getOneMonthData('expense');
  List<Map<String, dynamic>> choice = [
    {
      "type": 1,
      "dataType": "expense",
      "text": "Viw chart of one month  expense",
      "child": const OneMonthData(),
      "group":"month"
    },
    {
      "type": 2,
      "dataType": "expense",
      "text": "Viw chart of one Year  expense",
      "child": const OneYearIncomeExpense(),
      "group":"year"
    },
    {
      "type": 3,
      "dataType": 'expense',
      "text": "Viw chart of  Yearly  expense",
      "child": const YearlyExpense(),
      "group":"yearly"
    },
    {
      "type": 1,
      "dataType": "income",
      "text": "Viw chart of one month income",
      "child": const OneMonthIncome(),
      "group":"month"
    },
    {
      "type": 2,
      "dataType": "income",
      "text": "Viw chart of one Year  income",
      "child": const OneYearIncome(),
      "group":"year"
    },
    {
      "type": 3,
      "dataType": 'income',
      "text": "Viw chart of  Yearly income",
      "child": const YearlyIncome(),
      "group":"yearly"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    DetailsExpenseChart(
                      title: "Today Expense",
                      type: 3,
                      data: controller.todayExpenses,
                    ),
                    DetailsExpenseChart(
                      data: controller.todayIncome,
                      title: "Today Income",
                      type: 0,
                    ),
                    Wrap(
                      children: List.generate(choice.length, (index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: buildButton(
                              choice[index]['type'],
                              choice[index]['dataType'],
                              choice[index]['text'],
                              choice[index]['child'],
                              choice[index]['group']),
                        );
                      }),
                    ),
                    DetailsExpenseChart(
                      data: monthlyExpenses,
                      title: "Monthly Expenses",
                      type: 1,
                    ),
                    GenerateBarChart(
                      title: "Yearly Expense",
                      data: yearlyExpense,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget buildButton(int type, String dataType, String text, Widget page,String group) {
    return TextButton(
        onPressed: () {
          print(type);
          print(dataType);
          controller.getLongIncomeExpenseData(type, dataType);
          // controller.getLongIncomeExpenseData(type, 'expense');
          //  controller.getLongIncomeExpenseData(type+3, 'income');
          controller.getLongIncomeExpenseData(4, dataType,groupByTypes: group);
          if (type == 1) {
            controller.getGroupByData(dataType);
          }
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  reverseTransitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: ((context, animation, secondaryAnimation) {
                    return ScaleTransition(
                      scale: animation,
                      child: page,
                    );
                  })));
        },
        child: SmallText(
          text: text,
          color: constraints.secondaryColor,
        ));
  }
}
