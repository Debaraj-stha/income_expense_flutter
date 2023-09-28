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

class SearchDataPage extends StatefulWidget {
  const SearchDataPage({super.key, required this.title, required this.type});
  final String title;
  final String type;
  @override
  State<SearchDataPage> createState() => _SearchDataPageState();
}

class _SearchDataPageState extends State<SearchDataPage> {
  myController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Searched Data"),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.searchData.isNotEmpty
                      ? DetailsExpenseChart(
                          data: controller.searchData,
                          title: widget.title,
                          type: 0,
                        )
                      : const CircularProgressIndicator(),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => ListView.builder(
                        itemCount: controller.searchData.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (controller.searchData.isEmpty) {
                            return const CircularProgressIndicator();
                          } else if (controller.searchData.isEmpty) {
                            return const Center(
                              child: Text("No Data to show"),
                            );
                          } else {
                            final data = controller.searchData[index];
                            double ratio = double.parse(data['amount']) /
                                controller.searchTotal;
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
                                      .format(data['date'])
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
                      amount: "Rs ${(controller.searchTotal).toString()}"),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const BigText(text: "Expence on specific category"),
                  Obx(() => ListView.builder(
                      itemCount: controller.searchData.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (controller.searchData.isEmpty ||
                            controller.searchData.isEmpty) {
                          return const Center(
                            child: SmallText(text: "No data to show"),
                          );
                        } else {
                          final data = controller.searchData[index];

                          double ratio = double.parse(data['amount']) /
                              controller.searchTotal;
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
                      amount: "Rs${controller.searchTotal}"),
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
