import 'package:flutter/material.dart';
import 'package:income/model/constraints.dart';
import 'package:income/utils/bigText.dart';




class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(microseconds: 500));
    animation =
        Tween<Offset>(begin: const Offset(-300, 0), end: const Offset(0, 0))
            .animate(_controller);
            _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: animation.value,
          child: child,
        );
      },
      child: Container(
            alignment: Alignment.center,
            width: constraints().getHeight(context),
            height: constraints().getHeight(context),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BigText(
                  text: "Income and expense Tracker",
                  size: 30,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    child: const Image(image: AssetImage("asset/logo.png"))),
              ],
            ),
          )
    );
  }
}
