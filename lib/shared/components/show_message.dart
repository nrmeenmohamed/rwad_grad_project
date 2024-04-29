import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/colors.dart';

void showMessage(
  context, {
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17.sp,
        ),
      ),
      // Color(0xFF300103)
      backgroundColor: secondaryColor,
      dismissDirection: DismissDirection.up,
      duration: const Duration(milliseconds: 800),
    ),
  );
}
