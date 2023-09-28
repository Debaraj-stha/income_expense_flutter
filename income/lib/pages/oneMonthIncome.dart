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

class OneMonthIncome extends StatefulWidget {
  const OneMonthIncome({super.key});

  @override
  State<OneMonthIncome> createState() => _OneMonthIncomeState();
}

class _OneMonthIncomeState extends State<OneMonthIncome> {
  myController controller = Get.find();
  double total = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "One Month Income"),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.oneMonthIncome.isNotEmpty
                      ? DetailsExpenseChart(
                          data: controller.oneMonthIncome,
                          title: "One Month Income",
                          type: 0,
                        )
                      : const CircularProgressIndicator(),
                  const BigText(
                    text: "One Month Income Details",
                    family: "Poopins",
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  buildDropDownMenu(
                      controller.groupMonthDataIncome, 1, "income"),
                  Obx(
                    () => ListView.builder(
                        itemCount: controller.groupMonthDataIncome.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (controller.groupMonthDataIncome.isEmpty) {
                            return const CircularProgressIndicator();
                          } else if (controller.groupMonthData.isEmpty) {
                            return const Center(
                              child: Text("No Data to show"),
                            );
                          } else {
                            final data = controller.groupMonthDataIncome[index];
                            double ratio =
                                data['amount'] / controller.oneMOnthIncomeTotal;
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
                                      .format(DateTime.parse(data['date']))
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
                      amount:
                          "Rs ${(controller.oneMOnthIncomeTotal).toString()}"),
                  const SizedBox(
                    height: 20,
                  ),
                  GeneratePDF(
                    total: controller.oneMonthIncomeGroupByTitleTotal,
                    title: "One month Income source",
                    isDate: true,
                    data: controller.oneMonthIncomeGroupByTitle,
                  ),
                  const BigText(
                      text: "Income from specific category on one month"),
                  Obx(() => ListView.builder(
                      itemCount: controller.oneMonthIncomeGroupByTitle.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (controller.oneMonthIncomeGroupByTitle.isEmpty ||
                            controller.oneMonthIncomeGroupByTitle.isEmpty) {
                          return const Center(
                            child: SmallText(text: "No data to show"),
                          );
                        } else {
                          final data =
                              controller.oneMonthIncomeGroupByTitle[index];

                          double ratio = double.parse(data['amount']) /
                              controller.oneMonthIncomeGroupByTitleTotal;
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
                      amount:
                          "Rs${controller.oneMonthIncomeGroupByTitleTotal}"),
                  GeneratePDF(
                    total: controller.oneMonthIncomeGroupByTitleTotal,
                    title: "One month Income source",
                    isDate: false,
                    data: controller.oneMonthIncomeGroupByTitle,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
