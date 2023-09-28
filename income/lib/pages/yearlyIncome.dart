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

class YearlyIncome extends StatefulWidget {
  const YearlyIncome({super.key});

  @override
  State<YearlyIncome> createState() => _YearlyIncomeState();
}

class _YearlyIncomeState extends State<YearlyIncome> {
  myController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Yearly Income"),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.yearlyIncome.isNotEmpty
                      ? DetailsExpenseChart(
                          data: controller.yearlyIncome,
                          title: "Yearly Income",
                          type: 0,
                          dateType: const ['yyyy'],
                          indicatorTitle: 'date',
                        )
                      : const CircularProgressIndicator(),
                  const BigText(
                    text: "Yearly Income Details Year By Year",
                    family: "Poopins",
                    weight: FontWeight.w600,
                  ),
                  ListView.builder(
                      itemCount: controller.yearlyIncome.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (controller.yearlyIncome.isEmpty) {
                          return const CircularProgressIndicator();
                        } else if (controller.yearlyIncome.isEmpty) {
                          return const Center(
                            child: Text("No Data to show"),
                          );
                        } else {
                          final data = controller.yearlyIncome[index];

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
                          "Rs ${(controller.yearlyTotalIncome).toString()}"),
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
                      text: "Income from specific category on yearly "),
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
                  const SizedBox(
                    height: 20,
                  ),
                  GeneratePDF(
                    total: controller.oneMonthIncomeGroupByTitleTotal,
                    title: "Yearly Income source",
                    isDate: false,
                    data: controller.oneMonthIncomeGroupByTitle,
                  ),
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
