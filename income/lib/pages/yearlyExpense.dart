import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/model/controller.dart';
import 'package:intl/intl.dart';

import '../utils/appBar.dart';
import '../utils/bigText.dart';
import '../utils/buildIncomeExpensePercent.dart';
import '../utils/detailsExpense.dart';
import '../utils/generatePDFbutton.dart';
import '../utils/singleIncomeExpense.dart';
import '../utils/smallText.dart';

class YearlyExpense extends StatefulWidget {
  const YearlyExpense({super.key});

  @override
  State<YearlyExpense> createState() => _YearlyExpenseState();
}

class _YearlyExpenseState extends State<YearlyExpense> {
  myController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Yearly Expense"),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.yearlyExpense.isNotEmpty
                      ? DetailsExpenseChart(
                          data: controller.yearlyExpense,
                          title: "Yearly Expense",
                          type: 0,
                          dateType: const ['yyyy'],
                          indicatorTitle: 'date',
                        )
                      : const CircularProgressIndicator(),
                  const BigText(
                    text: "Yearly Expenses Details Year By Year",
                    family: "Poopins",
                    weight: FontWeight.w600,
                  ),
                  ListView.builder(
                      itemCount: controller.yearlyExpense.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (controller.yearlyExpense.isEmpty) {
                          return const CircularProgressIndicator();
                        } else if (controller.yearlyExpense.isEmpty) {
                          return const Center(
                            child: Text("No Data to show"),
                          );
                        } else {
                          final data = controller.yearlyExpense[index];

                          return SingleIncomeExpense(
                              title: DateFormat('yyyy').format(data['date']),
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
                          "Rs ${(controller.yearlyTotalExpense).toString()}"),
                  const SizedBox(
                    height: 20,
                  ),
                  GeneratePDF(
                    total: controller.oneMonthIncomeGroupByTitleTotal,
                    title: "One year Income source",
                    isDate: true,
                    data: controller.oneMonthIncomeGroupByTitle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const BigText(
                      text: "Expense on specific category on yearly "),
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
                    total: controller.oneMonthIncomeGroupByTitleTotal,
                    title: "Yearly expense source",
                    isDate: false,
                    data: controller.oneMonthIncomeGroupByTitle,
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
