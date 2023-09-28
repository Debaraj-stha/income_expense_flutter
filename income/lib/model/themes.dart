import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Themes {
  final lightTheme = ThemeData(
    fontFamily: "Roboto",
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
      textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      )),
    )),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  );

  final darkTheme = ThemeData(
    fontFamily: "Roboto",
    primaryColor: Colors.black,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        selectedIconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        selectedLabelStyle: TextStyle(
          color: Colors.white,
        ),
        unselectedItemColor: Colors.grey),
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white)),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
        color: Colors.indigo,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      )),
    )),
    textTheme: const TextTheme(
      labelLarge: TextStyle(color: Colors.orange),
      bodySmall: TextStyle(color: Colors.teal),
      displayLarge: TextStyle(color: Colors.purple),
      labelSmall: TextStyle(color: Colors.pink),
    ),
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)
        .copyWith(background: Colors.black),
  );
}

class ThemeServices {
  final _storage = GetStorage();
  final key = "isDarkTheme";
  bool isSavedThemeMode() {
    return _storage.read(key) ?? false;
  }

  ThemeMode getThemeMode() {
    return isSavedThemeMode() ? ThemeMode.dark : ThemeMode.light;
  }

  void saveThemeMode(bool isDarkMode) {
    _storage.write(key, isDarkMode);
  }

  void changeThemeMode() {
    Get.changeThemeMode(isSavedThemeMode() ? ThemeMode.light : ThemeMode.dark);
    saveThemeMode(!isSavedThemeMode());
  }
}
