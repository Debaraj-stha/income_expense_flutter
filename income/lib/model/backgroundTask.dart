import 'package:firebase_core/firebase_core.dart';
import 'package:income/model/notificationHandler.dart';
import 'package:workmanager/workmanager.dart';

import '../firebase_options.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    print("Task execution started");

    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBwE5NLn-EkkoedtAUDymmAmKHhR2wNDhw",
          appId: "1:841467742007:android:61c3b6209fa48f15c73cb2",
          messagingSenderId: "841467742007",
          projectId: "messaging-bcc60",
        ),
      ).whenComplete(() {
        print("Firebase initialized");
      });
      print("After Firebase initialization"); // Add this line
      NotificationHandler().getToken().then((value) async{
        print(value);
       await NotificationHandler().sendNotification(value);
      });
      // final token = await NotificationHandler().getToken();
      // print("Token: $token");
      // print("first dem,o");
      // Demo();
      // print("fdec");
      // if (token != null) {
      //   Demo();
      //   NotificationHandler().sendNotification(token);
      //   print("Notification sent");
      // } else {
      //   print("Token is null or invalid");
      // }
      print("Notification sent");
    } catch (e) {
      print("Error initializing Firebase: $e");
    }

    print("Task execution completed");
    return Future.value(true);
  });
}
