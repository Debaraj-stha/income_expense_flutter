import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/controller.dart';
import 'package:income/utils/smallText.dart';

Widget buildDropDownMenu(List data,int dataType,String types) {
  myController controller = Get.find();
  return DropdownMenu<int>(
      helperText: "Sort your data",
      label: const SmallText(text: "Sort data"),
      onSelected: (value) {
        controller.sortData(value!, data,dataType,types);
      },
      dropdownMenuEntries: const [
        DropdownMenuEntry(value: 1, label: "Date Asc"),
        DropdownMenuEntry(value: 2, label: "Date Desc"),
        DropdownMenuEntry(value: 3, label: "Value Asc"),
        DropdownMenuEntry(value: 4, label: "Value Desc")
      ]);
}
