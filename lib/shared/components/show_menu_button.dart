import 'package:flutter/material.dart';

import '../styles/colors.dart';

void showMenuButton(
  context, {
  required List<PopupMenuEntry> items,
  required RelativeRect position,
}) =>
    showMenu(
      color: lightGrey,
      context: context,
      position: position,
      items: items,
    );
