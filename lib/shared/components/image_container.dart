import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget imageContainer(
  context, {
  required Function onTap,
  required String image,
}) =>
    GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Image(
          image: CachedNetworkImageProvider(image),
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.25,
          fit: BoxFit.cover,
        ),
      ),
    );
