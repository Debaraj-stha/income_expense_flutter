import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/controller.dart';

import '../model/constraints.dart';
import 'smallText.dart';

class GenerateTextField extends StatelessWidget {
  GenerateTextField(
      {super.key,
      required this.controller,
      required this.label,
      this.isPassword = false,
      required this.regex,
      required this.icon});
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final RegExp regex;
  final bool isPassword;
  final myController _controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        // gradient: const LinearGradient(colors: [
        //   Colors.white,
        //   Colors.grey,
        // ]),
        border: Border.all(color: Colors.indigo, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: constraints.primaryColor,
          ),
          SizedBox(
            width: constraints().getWidth(context) * 0.8,
            child: TextFormField(
              controller: controller,
              enableInteractiveSelection: true,
              onFieldSubmitted: (value) {},
              validator: (value) {
                if (value!.isEmpty) {
                  return "This field is required";
                } else if (!regex.hasMatch(value)) {
                  return "Invalid field value.Please enter a valid value";
                }
                return null;
              },
              obscureText: _controller.isObsecured,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  label: SmallText(text: label)),
            ),
          ),
          isPassword
              ? InkWell(
                  onTap: () {
                    _controller.togglePassword();
                  },
                  child: Icon(
                    Icons.visibility_off,
                    color: constraints.primaryColor,
                  ))
              : Container()
        ],
      ),
    );
  }
}
