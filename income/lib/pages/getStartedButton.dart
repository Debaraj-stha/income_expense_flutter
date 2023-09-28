import 'package:flutter/material.dart';
import 'package:income/utils/bigText.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation animation;
  late Animation animationSequence;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animationSequence = TweenSequence(<TweenSequenceItem<Offset>>[
      TweenSequenceItem(
          tween: Tween(begin: const Offset(-6, -9), end: const Offset(0, 0)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween(begin: const Offset(0, 0), end: const Offset(-6, -9)),
          weight: 50)
    ]).animate(_controller);
    animation =
        Tween<Offset>(begin: const Offset(-6, -9), end: const Offset(0, 0))
            .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller
      ..reset()
      ..forward();
    return Scaffold(
        body: Center(
            child: AnimatedBuilder(
      animation: animationSequence,
      builder: (context, child) {
        return Transform.translate(
          offset: animationSequence.value,
          child: child,
        );
      },
      child: Container(
          child: TextButton(
        onPressed: () {},
        child: const BigText(
          text: "Get Started",
          size: 20,
          weight: FontWeight.w500,
          color: Colors.white,
        ),
      )),
    )));
  }
}
