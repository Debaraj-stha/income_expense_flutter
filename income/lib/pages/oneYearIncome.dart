import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:intl/intl.dart';

import '../model/controller.dart';
import '../utils/appBar.dart';
import '../utils/bigText.dart';
import '../utils/buildIncomeExpensePercent.dart';
import '../utils/detailsExpense.dart';
import '../utils/generatePDFbutton.dart';
import '../utils/singleIncomeExpense.dart';
import '../utils/smallText.dart';

class OneYearIncome extends StatefulWidget {
  const OneYearIncome({
    super.key,
  });

  @override
  State<OneYearIncome> createState() => _OneYearIncomeState();
}

class _OneYearIncomeState extends State<OneYearIncome> {
  myController controller = Get.find();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "One Year Income"),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.oneYearIncome.isNotEmpty
                      ? DetailsExpenseChart(
                          data: controller.oneYearIncome,
                          title: "One Year Income",
                          type: 0,
                          indicatorTitle: "date",
                          dateType: const ['MMMM'],
                        )
                      : const CircularProgressIndicator(),
                  const BigText(
                    text: "One Year Income Details Month By Month",
                  ),
                  ListView.builder(
                      itemCount: controller.oneYearIncome.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (controller.oneYearIncome.isEmpty) {
                          return const CircularProgressIndicator();
                        } else if (controller.oneYearIncome.isEmpty) {
                          return const Center(
                            child: Text("No Data to show"),
                          );
                        } else {
                          final data = controller.oneYearIncome[index];

                          return SingleIncomeExpense(
                              title: DateFormat('yyyy,MMMM')
                                  .format(data['date'])
                                  .toString(),
                              amount: "Rs ${data['amount']}");
                        }
                      }),
                  const Divider(
                    thickness: 2,
                  ),
                  SingleIncomeExpense(
                      title: "Total",
                      color: constraints.primaryColor,
                      amount:
                          "Rs ${(controller.oneYearTotalIncome).toString()}"),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GeneratePDF(
                      total: controller.oneMonthIncomeGroupByTitleTotal,
                      title: "One Year Income on specific day",
                      isDate: false,
                      data: controller.oneMonthIncomeGroupByTitle),
                  const SizedBox(
                    height: 20,
                  ),
                  const BigText(
                      text: "Income on specific category on one Year"),
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
                          "Rs${controller.oneMonthIncomeGroupByTitleTotal}"), //
                  const SizedBox(
                    height: 20,
                  ),
                  GeneratePDF(
                      total: controller.oneMonthIncomeGroupByTitleTotal,
                      title: "One Year Income Group By Category",
                      isDate: false,
                      data: controller.oneMonthIncomeGroupByTitle),
                ],
              ),
            )),
      ),
    );
  }
}
