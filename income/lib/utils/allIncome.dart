import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/utils/appBar.dart';
import 'package:income/utils/smallText.dart';

import '../model/controller.dart';
import 'singleIncomeExpense.dart';

class AllIncome extends StatefulWidget {
  const AllIncome({super.key});

  @override
  State<AllIncome> createState() => _AllIncomeState();
}

class _AllIncomeState extends State<AllIncome> {
  myController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(title: "All Income Source"),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
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
            Obx(() => ListView.builder(
                itemCount: controller.todayIncome.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = controller.todayIncome[index];
                  return SingleIncomeExpense(
                      title: data.title, amount: "Rs " + data.amount);
                })),
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
                  SmallText(
                    text: "Rs ${controller.total}",
                    color: constraints.primaryColor,
                  )
                ],
              ),
            ),
            TextButton(
                onPressed: () {},
                child: SmallText(
                  text: "View All",
                  color: constraints.secondaryColor,
                ))
          ],
        ),
      ),
    );
  }
}
