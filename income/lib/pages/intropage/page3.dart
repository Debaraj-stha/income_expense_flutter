import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:income/model/constraints.dart';
import 'package:income/utils/bigText.dart';
import 'package:income/utils/smallText.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  List<Map<String, dynamic>> features = [
    {"text": "Easy to use", "icon": Icons.check},
    {"text": "Secure and reliable", "icon": Icons.security},
    {
      "text": "Acceess from any where and any device",
      "icon": Icons.accessibility
    },
    {"text": "fast and free of cost", "icon": Icons.fast_forward}
  ];
  final List<Widget> _listTiles = [];
  final key = GlobalKey<AnimatedListState>();
  void addFeatures() {
    Future f = Future(() {});
    for (var u in features) {
      f = f.then((value) {
        return Future.delayed(const Duration(milliseconds: 100), () {
          _listTiles.add(buildTile(u));
          key.currentState!.insertItem(_listTiles.length - 1);
        });
      });
    }
  }

  Widget buildTile(element) {
    return ListTile(
      leading: Container(
          decoration: BoxDecoration(
              color: Colors.indigo, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Icon(
            element['icon'],
            color: Colors.white,
            size: 30,
          )),
      title: SmallText(text: element['text']),
    );
  }

  @override
  void initState() {
    addFeatures();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Tween<Offset> offset =
      Tween(begin: const Offset(1, 0), end: const Offset(0, 0));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                // width: constraints().getWidth(context),
                padding: const EdgeInsets.all(20),
                // height: constraints().getHeight(context) * 0.5,
                // color: Colors.indigo,
                child: SvgPicture.asset(
                  "asset/undraw_features_overview_re_2w78.svg",
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: BigText(text: "Key features"),
            ),
            AnimatedList(
                key: key,
                initialItemCount: _listTiles.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: ((context, index, animation) {
                  return SlideTransition(
                    position: animation.drive(offset),
                    child: _listTiles[index],
                  );
                })),
          ],
        ),
      ),
    );
  }
}
