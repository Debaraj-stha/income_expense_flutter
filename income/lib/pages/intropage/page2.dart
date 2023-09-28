import 'package:flutter/material.dart';

import '../../model/constraints.dart';
import '../../utils/bigText.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    animation =
        Tween<Offset>(begin: const Offset(0, -300), end: const Offset(0, 0))
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
          width: constraints().getWidth(context),
          height: constraints().getHeight(context),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const BigText(
                text: "Welcome to income and expense Tracker",
                size: 30,
                weight: FontWeight.bold,
              ),
              const SizedBox(
                height: 20,
              ),
              const BigText(
                text: "Your Personal Finance Manager",
                size: 25,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  child: const Image(
                      image:
                          AssetImage("asset/Managing-personal-finance.jpg"))),
            ],
          )),
    );
  }
}
