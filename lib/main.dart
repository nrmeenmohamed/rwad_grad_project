import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teknosoft/cubit/cubit.dart';
import 'package:teknosoft/shared/network/local/cache_helper.dart';
import 'package:teknosoft/shared/styles/theme.dart';

import '../services/work_manager_services.dart';
import 'cubit/bloc_observer.dart';
import 'layout/home_layout.dart';
import 'modules/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WorkManageServices().init(); // to run task in background
  //to improve performance of app when run
  // await Future.wait([
  //   LocalNotificationServices.init(), // Initialize notifications
  //   requestNotificationPermission(), // Request notification permission (for Android 13+)
  //   WorkManageServices().init(), // to run task in background
  // ]);

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  Widget widget;

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');

  if (onBoarding != null) {
    widget = const HomeLayout();
  } else {
    widget = const OnboardingScreen();
  }

  debugPrint('onBoarding = $onBoarding');

  runApp(MyApp(
    startWidget: widget,
  ));
}

// //Request notification permission (for Android 13+)
// Future<void> requestNotificationPermission() async {
//   // Check and request notification permission
//   PermissionStatus status = await Permission.notification.request();
//
//   if (status.isDenied) {
//     // The user denied notification permissions
//     print("Permission not granted for notifications.");
//   } else if (status.isPermanentlyDenied) {
//     // The user permanently denied notification permissions, open app settings
//     openAppSettings();
//   }
// }

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocProvider(
        create: (BuildContext context) => AppCubit()
          ..createDatabase()
          ..initializeBackgroundImage(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: timePickerTheme,
          home: startWidget,
        ),
      ),
    );
  }
}
