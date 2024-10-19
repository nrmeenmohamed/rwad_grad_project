import 'package:flutter/material.dart';

import '../styles/colors.dart';

Widget defaultButton({
  required String text,
  required Function onPressed,
}) =>
    ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
