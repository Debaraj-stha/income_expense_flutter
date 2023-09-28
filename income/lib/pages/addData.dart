import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/model/controller.dart';
import 'package:income/utils/addFieldPage.dart';

import 'package:income/utils/smallText.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({super.key});

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  myController controller = Get.find();
  PageController pageController = PageController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.addTextField(controller.textFieldList.length, context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 30),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                // Move the addTextField call here when the user taps "Add Field"
                controller.addTextField(
                    controller.textFieldList.length, context);
              },
              child: SmallText(
                text: "Add Field",
                color: constraints.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: PageView(
            controller: pageController,
            onPageChanged: (value) {
              controller.textEditingControllers.clear();
              controller.textFieldList.clear();
              controller.addTextField(controller.textFieldList.length, context);
            },
            children: const [
              AddFieldPage(
                title: "Add Income",
                type: 'income',
              ),
              AddFieldPage(
                type: 'expense',
                title: "Add Expense",
              )
            ]),
      ),
    );
  }
}
