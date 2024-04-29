import 'package:flutter/material.dart';
import 'package:teknosoft/layout/home_layout.dart';
import 'package:teknosoft/shared/components/onboarding_body.dart';
import 'package:teknosoft/shared/styles/colors.dart';

import '../shared/network/local/cache_helper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<String> imagesLink = [
    'https://www12.0zz0.com/2024/04/27/22/607839844.png',
    'https://www12.0zz0.com/2024/04/27/22/239226147.png',
    'https://www12.0zz0.com/2024/04/27/22/682657848.png',
    'https://www3.0zz0.com/2024/04/27/22/403022755.png',
  ];

  List<String> titles = [
    'Welcome to TaskHup !',
    'Effortless Task Management',
    'Organize Your Tasks',
    'Priority Levels',
  ];

  List<String> description = [
    'Let\'s get started on your journey to better task management.',
    'Add, edit, and delete tasks with ease. Stay on top of your to-do list effortlessly.',
    'Categorize your tasks into lists like Personal, Work, and Shopping. Stay organized and focused.',
    'Assign priority levels to your tasks. Focus on what matters most, whether it\'s high, medium, or low priority.',
  ];

  int lastPage = 0;

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: PageView(
            physics: const BouncingScrollPhysics(),
            controller: pageController,
            children: List.generate(
              titles.length,
              (index) => onboardingBody(
                context,
                imagesLink: imagesLink[index],
                title: titles[index],
                description: description[index],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryColor,
        child: const Icon(
          Icons.arrow_forward_ios_outlined,
        ),
        onPressed: () {
          setState(() {
            lastPage++;
          });
          if (lastPage < titles.length) {
            pageController.nextPage(
              duration: const Duration(milliseconds: 50),
              curve: Curves.bounceIn,
            );
          } else {
            CacheHelper.saveDate(key: 'onBoarding', value: true)
                .then((value) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeLayout(),
                      ),
                    ));
          }
        },
      ),
    );
  }
}
