import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/model/handleLocale.dart';
import 'package:income/model/themes.dart';

import 'package:income/utils/smallText.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final List locale = [
    {"name": "English", "locale": const Locale('en', 'US')},
    {"name": "नेपाली", "locale": const Locale('np', 'NPL')},
    {"name": "हिंदी", "locale": const Locale('hi', 'IN')}
  ];
  changeLanguage(Locale locale) {
    Get.updateLocale(locale);
  }

  buildPrompt(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: SmallText(text: "chnage_language".tr),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Get.back();
                        HandleLocale().changeLocale(locale[index]['locale']);
                        // changeLanguage();
                      },
                      title: SmallText(text: locale[index]['name']),
                    );
                  },
                  separatorBuilder: ((context, index) {
                    return const Divider(
                      color: Colors.blue,
                    );
                  }),
                  itemCount: locale.length),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        constraints.primaryColor,
                        constraints.thirdColor
                      ])),
                  currentAccountPicture:
                      const Image(image: AssetImage("asset/logo.png")),
                  accountName: SmallText(
                    text: "Jhon Doe",
                    color: constraints.secondaryColor,
                  ),
                  accountEmail: SmallText(
                    text: "jhon@gmail.com",
                    color: constraints.secondaryColor,
                  )),
            ),
            ListTile(
              onTap: () {
                buildPrompt(context);
              },
              leading: const Icon(Icons.language),
              title: SmallText(text: "chnage_language".tr),
            ),
            ExpansionTile(
              leading: const Icon(Icons.colorize),
              title: SmallText(text: "change_theme".tr),
              children: [
                ListTile(
                    onTap: () {
                      ThemeServices().changeThemeMode();
                    },
                    title: const SmallText(text: "Light Theme")),
                ListTile(
                    onTap: () {
                      ThemeServices().changeThemeMode();
                    },
                    title: const SmallText(text: "Syetem Theme")),
                ListTile(
                    onTap: () {
                      Get.changeThemeMode(ThemeMode.dark);
                    },
                    title: const SmallText(text: "Dark Theme")),
              ],
            ),
            TextButton(
                onPressed: () {},
                child: SmallText(
                  text: "logout".tr,
                  color: constraints.secondaryColor,
                ))
          ],
        ),
      ),
    );
  }
}
