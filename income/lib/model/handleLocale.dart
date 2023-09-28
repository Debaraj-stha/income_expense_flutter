import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HandleLocale {
  final _storage = GetStorage();
  final key = 'locale';

  void saveLocale(Locale locale) {
    try {
      _storage.write(key, locale);
    } catch (e) {
      rethrow;
    }
  }

  bool isSavedLocale() {
    return _storage.read(key) != null;
  }

  Locale getLocale() {
    print("locale${isSavedLocale()}");
    return isSavedLocale()
        ? const Locale('np', 'NPL')
        : const Locale('en', 'US');
  }

  void changeLocale(Locale locale) {
    try {
      print(locale);

      saveLocale(locale);
      Get.updateLocale(locale);
    } catch (e) {
      print('Error saving locale: $e');
    }
  }
}
