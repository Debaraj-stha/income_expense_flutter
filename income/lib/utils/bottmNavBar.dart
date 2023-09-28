import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/model/controller.dart';

class bottomBar extends StatefulWidget {
  const bottomBar({super.key});

  @override
  State<bottomBar> createState() => _bottomBarState();
}

class _bottomBarState extends State<bottomBar> {
  myController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: controller.activeTab,
      selectedItemColor: constraints.primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        controller.handleActiveTab(index);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Data"),
        BottomNavigationBarItem(
            icon: Icon(Icons.analytics), label: "Analyze your data"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
      ],
    );
  }
}
