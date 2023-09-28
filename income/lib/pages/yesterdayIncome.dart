import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/model/controller.dart';
import 'package:income/utils/appBar.dart';
import 'package:income/utils/bigText.dart';
import 'package:income/utils/buildDropDownMenu.dart';
import 'package:income/utils/buildIncomeExpensePercent.dart';
import 'package:income/utils/generatePDFbutton.dart';
import 'package:income/utils/singleIncomeExpense.dart';
import 'package:income/utils/smallText.dart';
import 'package:income/utils/specificDataChart.dart';
import 'package:intl/intl.dart';

import '../utils/detailsExpense.dart';

class YesterDayIncome extends StatefulWidget {
  const YesterDayIncome({super.key});

  @override
  State<YesterDayIncome> createState() => _YesterDayIncomeState();
}

class _YesterDayIncomeState extends State<YesterDayIncome> {
  myController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Yesterday Income"),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.yesterdayData.isNotEmpty
                      ? DetailsExpenseChart(
                          data: controller.yesterdayData,
                          title: "Yesterday Income",
                          type: 0,
                        )
                      : const CircularProgressIndicator(),
                  const BigText(
                    text: "Yesterday Income Income Details",
                    family: "Poopins",
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => ListView.builder(
                        itemCount: controller.yesterdayData.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (controller.yesterdayData.isEmpty) {
                            return const CircularProgressIndicator();
                          } else if (controller.groupMonthData.isEmpty) {
                            return const Center(
                              child: Text("No Data to show"),
                            );
                          } else {
                            final data = controller.yesterdayData[index];
                            double ratio = double.parse(data['amount']) /
                                controller.yesterdayTotal;
                            double percentage = ratio * 100;
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 500),
                                        reverseTransitionDuration:
                                            const Duration(milliseconds: 500),
                                        pageBuilder: ((context, animation,
                                            secondaryAnimation) {
                                          return SpecificDataChart(
                                            data: data['date'],
                                            type: "expense",
                                            isdate: true,
                                          );
                                        })));
                              },
                              child: buildIncomeExpenseProgress(
                                  data['amount'].toString(),
                                  constraints.primaryColor,
                                  DateFormat('yyyy-MM-dd')
                                      .format(data['date'])
                                      .toString(),
                                  percentage,
                                  context),
                            );
                            // return SingleIncomeExpense(
                            //     title: DateFormat('yyyy-MM-dd')
                            //         .format(DateTime.parse(data['date'])),
                            //     amount: "Rs ${data['amount']}");
                          }
                        }),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  SingleIncomeExpense(
                      title: "Total",
                      color: constraints.primaryColor,
                      amount: "Rs ${(controller.yesterdayTotal).toString()}"),
                  const SizedBox(
                    height: 20,
                  ),
                  GeneratePDF(
                    total: controller.yesterdayTotal,
                    title: "One month Income source",
                    isDate: true,
                    data: controller.yesterdayData,
                  ),
                  const BigText(
                      text: "Income from specific category on one month"),
                  Obx(() => ListView.builder(
                      itemCount: controller.yesterdayData.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (controller.yesterdayData.isEmpty ||
                            controller.yesterdayData.isEmpty) {
                          return const Center(
                            child: SmallText(text: "No data to show"),
                          );
                        } else {
                          final data = controller.yesterdayData[index];

                          double ratio = double.parse(data['amount']) /
                              controller.yesterdayTotal;
                          double percentage = ratio * 100;
                          return buildIncomeExpenseProgress(
                              data['amount'].toString(),
                              constraints.primaryColor,
                              data['title'],
                              percentage,
                              context);
                        }
                      })),
                  const Divider(
                    thickness: 2,
                  ),
                  SingleIncomeExpense(
                      title: "Total",
                      color: constraints.primaryColor,
                      amount: "Rs${controller.yesterdayTotal}"),
                  GeneratePDF(
                    total: controller.yesterdayTotal,
                    title: "One month Income source",
                    isDate: false,
                    data: controller.yesterdayData,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
