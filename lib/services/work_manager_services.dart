import 'package:workmanager/workmanager.dart';

import 'local_notification_services.dart';

class WorkManageServices {
  // init method

  void registerMyTask() async {
    await Workmanager().registerPeriodicTask(
      'uniqueName',
      'taskName',
      frequency: const Duration(days: 1),
    );
  }

  Future<void> init() async {
    await Workmanager().initialize(
        taskAction, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    registerMyTask();
  }

  // cancel
  static void cancelTask() {
    Workmanager().cancelByUniqueName('uniqueName');
  }
}

// must be on top level(entry point) to enable run
@pragma('vm:entry-point')
void taskAction() {
  Workmanager().executeTask((taskName, inputData) {
    print("WorkManager task executed: $taskName...........");
    LocalNotificationServices.showScheduledDailyNotification();
    return Future.value(true);
  });
}
