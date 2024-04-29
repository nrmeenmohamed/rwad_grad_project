import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teknosoft/cubit/cubit.dart';
import 'package:teknosoft/cubit/states.dart';
import 'package:teknosoft/shared/styles/colors.dart';

import '../shared/components/constants.dart';
import '../shared/components/image_container.dart';

class ThemeScreen extends StatelessWidget {
  ThemeScreen({super.key});

  List<String> images = [
    img1,
    img2,
    img3,
    img4,
    img5,
    img6,
    img7,
    img8,
    img9,
    img10,
    img11,
    img12
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: secondaryColor.withOpacity(0.7),
            title: Text(
              'Change background',
              style: TextStyle(
                  color: textColor,
                  //fontSize: 20.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                    image: CachedNetworkImageProvider(cubit.backgroundImage),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 0.63,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return imageContainer(
                                    context,
                                    onTap: () {
                                      cubit
                                          .changeBackgroundImage(images[index]);
                                    },
                                    image: images[index],
                                  );
                                },
                                itemCount: images.length,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
