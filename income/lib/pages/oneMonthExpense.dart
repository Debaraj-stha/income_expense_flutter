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

class OneMonthData extends StatefulWidget {
  const OneMonthData({super.key});

  @override
  State<OneMonthData> createState() => _OneMonthDataState();
}

class _OneMonthDataState extends State<OneMonthData> {
  myController controller = Get.find();
  double total = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "One Month Expense"),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.oneMonthExpenses.isNotEmpty
                      ? DetailsExpenseChart(
                          data: controller.oneMonthExpenses,
                          title: "One Month Expense",
                          type: 0,
                        )
                      : const CircularProgressIndicator(),
                  const BigText(
                    text: "One Month Expenses Details ",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  buildDropDownMenu(controller.groupMonthData, 1, 'expense'),
                  Obx(
                    () => ListView.builder(
                        itemCount: controller.groupMonthData.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (controller.groupMonthData.isEmpty) {
                            return const CircularProgressIndicator();
                          } else if (controller.groupMonthData.isEmpty) {
                            return const Center(
                              child: Text("No Data to show"),
                            );
                          } else {
                            final data = controller.groupMonthData[index];
                            double ratio = data['amount'] /
                                controller.oneMOnthExpenseTotal;
                            double percentage = ratio * 100;
                            print(data['amount']);
                            return InkWell(
                              onTap: () {
                                DateTime startDate =
                                    DateTime.parse(data['date']);
                                DateTime endDate = DateTime(startDate.year,
                                    startDate.month, startDate.day);
                                controller.getSpecificData(
                                    'expense', data['date'], true,
                                    startDate: startDate.toLocal().toString(),
                                    endDate: endDate.toLocal().toString());
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
                          "Rs ${(controller.oneMOnthExpenseTotal).toString()}"),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GeneratePDF(
                      total: controller.oneMonthExpenseGroupByTitleTotal,
                      title: "One Month Expense on Specific day",
                      isDate: true,
                      data: controller.oneMonthExpenseGroupByTitle),
                         const SizedBox(
                    height: 20,
                  ),
                  const BigText(
                      text: "Expence on specific category on one month"),
                  Obx(() => ListView.builder(
                      itemCount: controller.oneMonthExpenseGroupByTitle.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (controller.oneMonthExpenseGroupByTitle.isEmpty ||
                            controller.oneMonthExpenseGroupByTitle.isEmpty) {
                          return const Center(
                            child: SmallText(text: "No data to show"),
                          );
                        } else {
                          final data =
                              controller.oneMonthExpenseGroupByTitle[index];

                          double ratio = double.parse(data['amount']) /
                              controller.oneMonthExpenseGroupByTitleTotal;
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
                          "Rs${controller.oneMonthExpenseGroupByTitleTotal}"),
                  const SizedBox(
                    height: 20,
                  ),
                  GeneratePDF(
                      total: controller.oneMonthExpenseGroupByTitleTotal,
                      title: "One Month Expense Group By Category",
                      isDate: false,
                      data: controller.oneMonthExpenseGroupByTitle),
                         const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
