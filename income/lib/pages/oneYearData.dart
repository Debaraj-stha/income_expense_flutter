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

class OneYearIncomeExpense extends StatefulWidget {
  const OneYearIncomeExpense({
    super.key,
  });

  @override
  State<OneYearIncomeExpense> createState() => _OneYearIncomeExpenseState();
}

class _OneYearIncomeExpenseState extends State<OneYearIncomeExpense> {
  myController controller = Get.find();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "One Year  Expense"),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.oneYearExpense.isNotEmpty
                      ? DetailsExpenseChart(
                          data: controller.oneYearExpense,
                          title: "One Year Expense",
                          type: 0,
                          indicatorTitle: "date",
                          dateType: const ['MMMM'],
                        )
                      : const CircularProgressIndicator(),
                  const BigText(
                    text: "One Year Expense Details Month By Month",
                  ),
                  ListView.builder(
                      itemCount: controller.oneYearExpense.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (controller.oneYearExpense.isEmpty) {
                          return const CircularProgressIndicator();
                        } else if (controller.oneYearExpense.isEmpty) {
                          return const Center(
                            child: Text("No Data to show"),
                          );
                        } else {
                          final data = controller.oneYearExpense[index];

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
                          "Rs ${(controller.oneYearTotalExpense).toString()}"),
                  const SizedBox(
                    height: 30,
                  ),
                     BigText(text:  "Expense on specific category on one Year"),
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
                          "Rs${controller.oneMonthExpenseGroupByTitleTotal}"),// 
                  const SizedBox(
                    height: 20,
                  ),
                  GeneratePDF(
                      total: controller.oneMonthExpenseGroupByTitleTotal,
                      title: "One Year Expense Group By Category",
                      isDate: false,
                      data: controller.oneMonthExpenseGroupByTitle),
                ],
              ),
            )),
      ),
    );
  }
}
