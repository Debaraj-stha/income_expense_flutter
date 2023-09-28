import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/model/controller.dart';
import 'package:income/utils/singleIncomeExpense.dart';
import 'package:income/utils/smallText.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  myController controller = Get.find();
  Tween<Offset> offset =
      Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0));
  @override
  void initState() {
    // TODO: implement initState
    if (controller.todayExpenses.isEmpty || controller.todayExpenses.isEmpty) {
      controller.getTodayIncomeExpense("expense");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallText(
                        text: "Todays Expense title",
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
                      key: controller.expenseKey,
                      initialItemCount: controller.todayExpenses.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index, animation) {
                        if (controller.todayExpenses.isEmpty) {
                          return Center(
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 30),
                                child: const SmallText(
                                    text:
                                        "You do not have updated your expense")),
                          );
                        } else if (controller.todayExpenses.isEmpty) {
                          return Center(
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 30),
                                child: const CircularProgressIndicator()),
                          );
                        } else {
                          final data = controller.todayExpenses[index];
                          print(data);

                          return SlideTransition(
                              position: animation.drive(offset),
                              child: SingleIncomeExpense(
                                  title: data['title'],
                                  amount: "Rs " + data['amount']));
                        }
                      });
                }),
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
                            text: "Rs ${controller.totalExpense}",
                            color: constraints.primaryColor,
                          ))
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
    );
  }
}
