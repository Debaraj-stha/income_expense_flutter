import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/model/controller.dart';

import 'smallText.dart';

class AddFieldPage extends StatefulWidget {
  const AddFieldPage({super.key, required this.title, required this.type});
  final String title;
  final String type;
  @override
  State<AddFieldPage> createState() => _AddFieldPageState();
}

class _AddFieldPageState extends State<AddFieldPage> {
  myController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SmallText(
            text: widget.title,
          ),
          Obx(
            () => Container(
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: controller.textFieldList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return controller.textFieldList[index];
                    })),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {
                controller.addData(widget.type, context);
              },
              child: SmallText(
                text: "Add",
                color: constraints.secondaryColor,
              ))
        ],
      ),
    );
  }
}
