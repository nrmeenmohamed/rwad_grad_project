import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../layout/home_layout.dart';
import '../network/local/cache_helper.dart';
import '../styles/colors.dart';

Widget onboardingBody(
  context, {
  required String imagesLink,
  required String title,
  required String description,
}) =>
    Column(
      children: [
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: TextButton(
            onPressed: () {
              CacheHelper.saveDate(key: 'onBoarding', value: true)
                  .then((value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeLayout(),
                        ),
                      ));
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: secondaryColor,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
        Image(
          image: CachedNetworkImageProvider(
            imagesLink,
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.7,
          fit: BoxFit.cover,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.5,
            fontSize: 17.sp,
          ),
        ),
      ],
    );
