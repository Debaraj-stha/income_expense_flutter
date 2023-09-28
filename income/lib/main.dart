import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:income/model/controller.dart';
import 'package:income/model/handleLocale.dart';
import 'package:income/model/localeString.dart';
import 'package:income/model/themes.dart';
import 'package:income/pages/loginPage.dart';
import 'package:workmanager/workmanager.dart';

import 'model/backgroundTask.dart';
import 'model/notificationHandler.dart';
import 'pages/pageHandler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize(debug: true);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // tz.initializeTimeZones();
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  // await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await GetStorage.init();
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("backgroundMessageHandler");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      locale: HandleLocale().getLocale(),
      translations: LocaleString(),
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      theme: Themes().lightTheme,
      darkTheme: Themes().darkTheme,
      themeMode: ThemeServices().getThemeMode(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  myController controller = Get.put(myController());

  @override
  void initState() {
    super.initState();
    NotificationHandler().initMessage(context);
    NotificationHandler().getToken().then((value) {
      print(value);
      NotificationHandler().sendNotification(value);
    });
    // Initialize Firebase and local notifications

    // Schedule the background task to run at a specific time
    Map<String, dynamic> data = {
      "message": "testing scheduled background task"
    };
    // Workmanager().registerOneOffTask(
    //   '1',
    //   'simpleTask',
    //   inputData: data,
    //   initialDelay:
    //       const Duration(seconds: 30), // Delay before running the task
    // );

    NotificationHandler().initMessage(context);
    NotificationHandler().interactMessage(context);
    isAlreadyLoggedIn();
  }

  Future<void> isAlreadyLoggedIn() async {
    final value = await controller.getUserInfo();
    print(value.toList()); // Use the safe navigation operator "?"
    if (value.isEmpty) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const PageHandler();
  }
}
