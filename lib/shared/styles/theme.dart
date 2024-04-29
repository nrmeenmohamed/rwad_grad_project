import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData timePickerTheme = ThemeData(
  timePickerTheme: TimePickerThemeData(
    backgroundColor: lightGrey,
    hourMinuteShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Colors.orange, width: 2),
    ),
    dayPeriodBorderSide: const BorderSide(color: Colors.orange, width: 4),
    dayPeriodColor: Colors.blueGrey.shade600,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Colors.orange, width: 4),
    ),
    dayPeriodTextColor: Colors.white,
    dayPeriodShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Colors.orange, width: 4),
    ),
    hourMinuteColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? Colors.orange
            : Colors.blueGrey.shade800),
    hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected) ? Colors.white : Colors.orange),
    dialHandColor: Colors.blueGrey.shade700,
    dialBackgroundColor: Colors.blueGrey.shade800,
    hourMinuteTextStyle:
        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    dayPeriodTextStyle:
        const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    helpTextStyle: const TextStyle(
        fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(0),
    ),
    dialTextColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected) ? Colors.orange : Colors.white),
    entryModeIconColor: Colors.orange,
    cancelButtonStyle: ButtonStyle(
      textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
        (states) {
          return TextStyle(
            color: secondaryColor,
          );
        },
      ),
    ),
  ),
);
