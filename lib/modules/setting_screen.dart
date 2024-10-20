import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teknosoft/cubit/cubit.dart';
import 'package:teknosoft/cubit/states.dart';
import 'package:teknosoft/services/local_notification_services.dart';
import 'package:teknosoft/shared/styles/colors.dart';

import '../services/work_manager_services.dart';
import '../shared/components/constants.dart';
import '../shared/components/image_container.dart';
import '../shared/network/local/cache_helper.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<String> images = [
    img1,
    img2,
    img3,
    img4,
    img5,
    img6,
    img7,
    img8,
    img9,
    img10,
    img11,
    img12
  ];

  bool activeNotification = false;

  @override
  void initState() {
    super.initState();
    initializeServices();
    loadNotificationPreference();
  }

  void initializeServices() async {
    print("Initializing services..........");
    await Future.wait([
      LocalNotificationServices.init(), // Initialize notifications
      WorkManageServices().init(), // Initialize background tasks
    ]);
  }

  // Load notification preference
  void loadNotificationPreference() async {
    bool? savedNotificationPreference = await CacheHelper.getData(
        key: 'activeNotification'); // Load saved value
    setState(() {
      activeNotification = savedNotificationPreference ?? false;
    });
  }

  // Method to handle the notification toggle
  void toggleNotification(bool value) async {
    setState(() {
      activeNotification = value; // Update the switch state
    });

    if (value) {
      PermissionStatus status = await Permission.notification.request();
      if (status.isGranted) {
        LocalNotificationServices.showScheduledDailyNotification();
      } else {
        openAppSettings(); // Open app settings if permission denied
      }
    } else {
      LocalNotificationServices.cancelAllNotification();
      // WorkManageServices.cancelTask();
    }

    CacheHelper.saveDate(
        key: 'activeNotification', value: value); // Save the updated preference
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: secondaryColor.withOpacity(0.7),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: Text(
              'Setting',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                    image: CachedNetworkImageProvider(cubit.backgroundImage),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Change background',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 22.sp),
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              height: 150.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return imageContainer(
                                    context,
                                    onTap: () {
                                      cubit
                                          .changeBackgroundImage(images[index]);
                                    },
                                    image: images[index],
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Notification',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22.sp)),
                                Switch(
                                  value: activeNotification,
                                  onChanged: toggleNotification,
                                  activeColor: secondaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
