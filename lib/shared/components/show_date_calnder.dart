import 'dart:ui';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teknosoft/shared/styles/colors.dart';

Widget showDateCalender() => Stack(
      children: [
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: backgroundColor,
          ),
          padding: const EdgeInsetsDirectional.all(8),
          child: SizedBox(
            height: 80.h,
            child: DatePicker(
              DateTime.now(),
              initialSelectedDate: DateTime.now(),
              selectionColor: secondaryColor,
              selectedTextColor: textColor,
              dateTextStyle: TextStyle(
                color: textColor,
              ),
              dayTextStyle: TextStyle(
                color: textColor,
              ),
              monthTextStyle: TextStyle(
                color: textColor,
              ),
              onDateChange: (date) {},
            ),
          ),
        ),
      ],
    );
