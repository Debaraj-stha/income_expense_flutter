import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/model/controller.dart';
import 'package:income/utils/bigText.dart';
import 'package:income/utils/indicator.dart';
import 'package:income/utils/smallText.dart';

class IncomeExpenseChart extends StatefulWidget {
  const IncomeExpenseChart({super.key});

  @override
  State<IncomeExpenseChart> createState() => _IncomeExpenseChartState();
}

class _IncomeExpenseChartState extends State<IncomeExpenseChart>
    with SingleTickerProviderStateMixin {
  double income = 1698622;
  double expense = 6379982;
  int touchIndex = -1;
  late AnimationController _controller;
  late Animation<double> _animation;
  myController controller = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 100, end: 300).animate(_controller);

    _controller
      ..reset()
      ..forward();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controller.todayExpenses.isNotEmpty ||
            controller.todayIncome.isNotEmpty
        ? Obx(() => Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return SizedBox(
                                width: _animation.value,
                                height: 200,
                                child: Obx(
                                  () => PieChart(
                                    PieChartData(
                                        sectionsSpace: 6,
                                        pieTouchData: PieTouchData(
                                          touchCallback: (FlTouchEvent event,
                                              pieTouchResponse) {
                                            setState(() {
                                              if (!event
                                                      .isInterestedForInteractions ||
                                                  pieTouchResponse == null ||
                                                  pieTouchResponse
                                                          .touchedSection ==
                                                      null) {
                                                touchIndex = -1;
                                                return;
                                              }
                                              touchIndex = pieTouchResponse
                                                  .touchedSection!
                                                  .touchedSectionIndex;
                                            });
                                            print(touchIndex);
                                          },
                                        ),
                                        sections: showingSections()),
                                    swapAnimationDuration:
                                        const Duration(milliseconds: 150),
                                    swapAnimationCurve: Curves.linear,
                                  ),
                                ));
                          }),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Indicator(
                              color: Colors.green,
                              text: "Income",
                              isSquare: true),
                          Indicator(
                              color: Colors.red,
                              text: "Expense",
                              isSquare: true)
                        ],
                      ),
                    ],
                  ),
                  const BigText(text: "Income and Expenses chart")
                ],
              ),
            ))
        : Container();
  }

  List<PieChartSectionData> showingSections() {
    myController controller = Get.find();
    return List.generate(2, (i) {
      final isTouched = i == touchIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.green,
            value: controller.total,
            title: '${controller.total}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: constraints.primaryColor,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: controller.totalExpense,
            title: '${controller.totalExpense}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: constraints.primaryColor,
              shadows: shadows,
            ),
          );

        default:
          throw Error();
      }
    });
  }
}
