import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teknosoft/cubit/cubit.dart';
import 'package:teknosoft/cubit/states.dart';
import 'package:teknosoft/shared/network/local/cache_helper.dart';
import 'package:teknosoft/shared/styles/theme.dart';

import 'cubit/bloc_observer.dart';
import 'layout/home_layout.dart';
import 'modules/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          ..getCategory()
          ..getTask()
          ..initializeBackgroundImage(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {},
          builder: (BuildContext context, AppStates state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: timePickerTheme,
              home: startWidget,
            );
          },
        ),
      ),
    );
  }
}
