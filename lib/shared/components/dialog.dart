import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../styles/colors.dart';

void dialog(
  context, {
  required DialogType dialogType,
  required String title,
  String? btnOkText,
  Function? btnCancelOnPress,
  Function? btnOkOnPress,
}) =>
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.rightSlide,
      title: title,
      desc: 'are you sure ?',
      btnOkText: btnOkText,
      btnOkColor: secondaryColor,
      btnCancelColor: Colors.red,
      btnCancelOnPress: () {
        btnCancelOnPress!();
      },
      btnOkOnPress: () {
        btnOkOnPress!();
      },
    ).show();
