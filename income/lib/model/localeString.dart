import 'package:get/get.dart';

class LocaleString extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        "en_US": {
          "home": "Home",
          "account": "Account",
          "add": "Add Data",
          "analyze": "Analyze Your Data",
          "chnage_language": "change language",
          "change_theme": "Change Theme",
          "logout": "Logout"
        },
        'ne_NP': {
          "home": "घर",
          "account": "खाता",
          "add": "डाटा थप्नुहोस्",
          "analyze": "आफ्नो डाटा विश्लेषण गर्नुहोस्",
          "chnage_language": "भाषा परिवर्तन",
          "change_theme": "विषयवस्तु परिवर्तन गर्नुहोस्",
          "logout": "बाहिर निस्कनु"
        },
        'hi_IN': {
          "home": "घर",
          "account": "खाता",
          "add": "डेटा जोड़ें",
          "analyze": "अपने डेटा का विश्लेषण करें",
          "chnage_language": "भाषा बदलें",
          "change_theme": "विषय को परिवर्तित करें",
          "logout": "लॉग आउट"
        }
      };
}
