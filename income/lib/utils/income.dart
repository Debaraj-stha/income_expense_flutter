import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/model/controller.dart';
import 'package:income/utils/allIncome.dart';
import 'package:income/utils/singleIncomeExpense.dart';
import 'package:income/utils/smallText.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Income extends StatefulWidget {
  const Income({super.key});

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  myController controller = Get.find();
  String url = "https://download.samplelib.com/mp4/sample-5s.mp4";
  Tween<Offset> offset =
      Tween(begin: const Offset(1, 0), end: const Offset(0, 0));
  @override
  @override
  void initState() {
    // TODO: implement initState

    if (controller.todayIncome.isEmpty || controller.todayIncome.isEmpty) {
      controller.getTodayIncomeExpense('income');
    }
    controller.getGroupByData('expense');
   
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SmallText(
                text: "Todays Income Source",
                color: constraints.primaryColor,
              ),
              SmallText(
                text: "Amount",
                color: constraints.primaryColor,
              )
            ],
          ),
        ),
        Obx(() {
          return AnimatedList(
              key: controller.incomeKey,
              initialItemCount: controller.todayIncome.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index, animation) {
                if (controller.todayIncome.isEmpty) {
                  return Center(
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: const SmallText(
                            text: "You do not have updated your expense")),
                  );
                } else if (controller.todayIncome.isEmpty) {
                  return Center(
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: const CircularProgressIndicator()),
                  );
                } else {
                  final data = controller.todayIncome[index];
                  return SlideTransition(
                      position: animation.drive(offset),
                      child: SingleIncomeExpense(
                          title: data['title'],
                          amount: "Rs " + data['amount']));
                }
              });
        }),
        // Obx(() => ListView.builder(
        //     itemCount: controller.todayIncome.length > 7
        //         ? 7
        //         : controller.todayIncome.length,
        //     shrinkWrap: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemBuilder: (context, index) {
        //       final data = controller.todayIncome[index];
        //       return SingleIncomeExpense(
        //           title: data['title'], amount: data['amount']);
        //     })),
        const Divider(
          thickness: 2,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SmallText(
                text: "Total",
                color: constraints.primaryColor,
              ),
              Obx(() => SmallText(
                    text: "Rs ${controller.total}",
                    color: constraints.primaryColor,
                  ))
            ],
          ),
        ),
        controller.todayIncome.length > 5
            ? TextButton(
                onPressed: () {
                  Get.to(const AllIncome());
                },
                child: SmallText(
                  text: "View All",
                  color: constraints.secondaryColor,
                ))
            : Container()
      ],
    );
    // : Column(
    //     children: [
    //       Container(
    //           child: const Center(
    //         child:
    //             SmallText(text: "You do not have added today income data"),
    //       )),
    //       Container(
    //           child: const Center(
    //         child: SmallText(text: "Add data to view chart"),
    //       )),
    //       const SizedBox(
    //         height: 30,
    //       ),
    //       TextButton(
    //           onPressed: () {
    //             controller.handleActiveTab(1);
    //           },
    //           child: SmallText(
    //             text: "Add now",
    //             color: constraints.secondaryColor,
    //           )),
    //       const SizedBox(
    //         height: 30,
    //       ),
    //     ],
    //   );
  }
}
