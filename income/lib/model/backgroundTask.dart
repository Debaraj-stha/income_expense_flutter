import 'package:workmanager/workmanager.dart';
import 'package:income/model/notificationHandler.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    print("called");
    // This is where you can schedule your notifications at the desired time
    final token = await NotificationHandler().getToken();
    NotificationHandler().scheduleNotification(token);
    return Future.value(true);
  });
}
