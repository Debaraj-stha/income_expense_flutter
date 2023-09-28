import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';

import 'package:income/pages/accountPage.dart';
import 'package:income/pages/analyzeDataPage.dart';
import 'package:income/pages/homePage.dart';
import 'package:income/pages/addData.dart';

import '../model/controller.dart';

class PageHandler extends StatefulWidget {
  const PageHandler({super.key});

  @override
  State<PageHandler> createState() => _PageHandlerState();
}

class _PageHandlerState extends State<PageHandler> {
  myController controller = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final List<Widget> _pages = [
     HomePage(),
    const AddDataPage(),
    const AnalyzeDataPage(),
    const AccountPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          body: Center(child: _pages[controller.activeTab]),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.activeTab,
            selectedItemColor: constraints.primaryColor,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              controller.textFieldList.clear();
              controller.textEditingControllers.clear();
              controller.handleActiveTab(index);
              // controller.addTextField(0, context);
            },
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home), label: 'home'.tr),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.add), label: 'add'.tr),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.analytics), label: "analyze".tr),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.person), label: "account".tr),
            ],
          ));
    });
  }
}
