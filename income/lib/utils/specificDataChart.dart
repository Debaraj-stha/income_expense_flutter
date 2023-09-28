import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/controller.dart';
import 'package:income/utils/detailsExpense.dart';
import 'package:income/utils/smallText.dart';

class SpecificDataChart extends StatefulWidget {
  const SpecificDataChart(
      {super.key, this.isdate = false, required this.data, required this.type});
  final bool isdate;
  final String data;
  final String type;
  @override
  State<SpecificDataChart> createState() => _SpecificDataChartState();
}

class _SpecificDataChartState extends State<SpecificDataChart> {
  myController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              controller.specificData.isNotEmpty
                  ? Obx(() => DetailsExpenseChart(
                        title: widget.data,
                        type: 0,
                        data: controller.specificData,
                      ))
                  : Container(
                      child: const SmallText(text: "Data not available"),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
