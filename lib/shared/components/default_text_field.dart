import 'package:flutter/material.dart';
import '../styles/colors.dart';

Widget defaultTextField({
  required TextEditingController controller,
  required String labelText,
  required IconData prefixIcon,
  Function(String?)? validator,
  String? helperText,
  Function? onTap,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
}) =>
    TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: helperText,
          labelText: labelText,
          labelStyle: TextStyle(
            color: secondaryColor,
          ),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: secondaryColor,
            ),
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: secondaryColor,
          ),
        ),
        cursorColor: secondaryColor,
        validator: (value) {
          return validator!(value);
        },
        onFieldSubmitted: (value) {},
        onTap: onTap as void Function()?);
