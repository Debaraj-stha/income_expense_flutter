import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/model/controller.dart';
import 'package:income/pages/getStartedButton.dart';
import 'package:income/pages/intropage/page1.dart';
import 'package:income/pages/intropage/page2.dart';
import 'package:income/pages/intropage/page3.dart';

import 'package:income/utils/smallText.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _controller = PageController();
  myController controller = Get.put(myController());
  ValueNotifier<int> currentPageNotifier = ValueNotifier(0);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    const Page1(),
    const Page2(),
    const Page3(),
    const GetStarted()
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              ValueListenableBuilder(
                  valueListenable: currentPageNotifier,
                  builder: ((context, value, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const GetStarted()));
                          },
                          child: SmallText(
                            text: value != _pages.length - 1 ? "Skip" : "Next",
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  })),
              SizedBox(
                width: constraints().getWidth(context),
                height: constraints().getHeight(context) * 0.8,
                child: PageView(
                  controller: _controller,
                  onPageChanged: (value) {
                    currentPageNotifier.value = value;
                    debugPrint('currentPage: $currentPage');
                  },
                  children: _pages,
                ),
              ),
              SmoothPageIndicator(
                controller: _controller,
                count: _pages.length,
                effect: const JumpingDotEffect(),
                onDotClicked: (index) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
