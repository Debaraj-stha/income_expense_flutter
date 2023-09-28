import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/model/controller.dart';
import 'package:income/utils/bigText.dart';
import 'package:income/utils/indicator.dart';
import 'package:income/utils/smallText.dart';
import 'package:intl/intl.dart';

class DetailsExpenseChart extends StatefulWidget {
  const DetailsExpenseChart(
      {super.key,
      this.data,
      required this.title,
      required this.type,
      this.indicatorTitle = 'title',
      this.dateType = const []});
  final data;
  final String title;
  final List dateType;
  final int type;
  final String indicatorTitle;
  @override
  State<DetailsExpenseChart> createState() => _DetailsExpenseChartState();
}

class _DetailsExpenseChartState extends State<DetailsExpenseChart> {
  List<Color> generatedColor = [];
  myController controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    generatedColor = List.generate(
        widget.data.length, (index) => controller.generateColor());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String dateFormat = widget.dateType.join(",");
    return widget.data.isNotEmpty || widget.data.length != 0
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => SizedBox(
                        width: constraints().getWidth(context) * 0.6,
                        height: 200,
                        child: PieChart(PieChartData(
                            pieTouchData: PieTouchData(
                                enabled: true,
                                touchCallback: (FlTouchEvent event,
                                    PieTouchResponse? pieTouchResponse) {
                                  if (pieTouchResponse != null) {
                                    controller.handlepichartTouch(
                                        event, pieTouchResponse, widget.type);
                                  }
                                }),
                            sections:
                                List.generate(widget.data.length, (index) {
                              return PieChartSectionData(
                                  title: widget.data[index]['amount'].toString(),
                                  color: generatedColor[index],
                                  radius: 100,
                                  titleStyle: TextStyle(
                                      fontSize: widget.type == 1
                                          ? controller.currentTouchBar == index
                                              ? 15
                                              : 12
                                          : controller.monthlyExpenses == index
                                              ? 15
                                              : 12),
                                  value:double.parse(widget.data[index]["amount"].toString()))
;
                            })))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(widget.data.length, (index) {
                      return Indicator(
                          color: generatedColor[index],
                          text: widget.indicatorTitle == 'date'
                              ? DateFormat(dateFormat)
                                  .format(widget.data[index]['date'])
                                  .toString()
                              : widget.data[index]['title'].toString(),
                          isSquare: true);
                    }),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              BigText(text: widget.title),
              const SizedBox(
                height: 30,
              ),
            ],
          )
        : const Center(
            child: SmallText(text: "You do not have added data"),
          );
  }
}
