import 'package:flutter/material.dart';

import '../styles/colors.dart';

Widget defaultDropdownMenu({
  double? width,
  required String label,
  IconData? leadingIcon,
  required List<DropdownMenuEntry> dropdownMenuEntries,
  required Function onSelected,
  String? initialSelection,
}) =>
    DropdownMenu(
      width: width,
      label: Text(
        label,
        style: TextStyle(
          color: secondaryColor,
        ),
      ),
      initialSelection: initialSelection,
      leadingIcon: Icon(
        leadingIcon,
        color: secondaryColor,
      ),
      menuStyle: MenuStyle(
        side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(
              color: Colors.black,
              width: 0.3,
            )),
      ),
      dropdownMenuEntries: dropdownMenuEntries,
      onSelected: (value) {
        onSelected(value);
      },
    );
