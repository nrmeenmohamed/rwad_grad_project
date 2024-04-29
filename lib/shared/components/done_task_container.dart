import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/colors.dart';

Widget doneTaskContainer({
  required Map taskModel,
  required Function onLongPress,
}) =>
    GestureDetector(
      onLongPress: () {
        onLongPress();
      },
      child: Container(
        padding: const EdgeInsetsDirectional.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              taskModel['title'],
              style: TextStyle(
                color: textColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              taskModel['description'],
              style: TextStyle(
                color: textColor,
                fontSize: 17.sp,
                fontWeight: FontWeight.w300,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
