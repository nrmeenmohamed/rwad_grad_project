import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teknosoft/cubit/cubit.dart';
import 'package:teknosoft/cubit/states.dart';
import 'package:teknosoft/models/task_model.dart';
import 'package:teknosoft/modules/theme_screen.dart';
import 'package:teknosoft/shared/components/default_dropdown_menu.dart';
import 'package:teknosoft/shared/styles/colors.dart';
import '../shared/components/constants.dart';
import '../shared/components/default_button.dart';
import '../shared/components/default_text_field.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  TextEditingController timeController = TextEditingController();

  String category = '';

  String priority = '';

  bool isBottomSheetOpen = false;

  int categoryId = 0;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(cubit.backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              titleSpacing: 20.0,
              backgroundColor: backgroundColor,
              title: const Text(
                'TaskHup',
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThemeScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.imagesearch_roller_outlined),
                ),
              ],
            ),
            bottomNavigationBar: Stack(
              children: [
                Positioned.fill(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(20.r),
                      topEnd: Radius.circular(20.r),
                    ),
                    color: backgroundColor,
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    unselectedItemColor: textColor,
                    selectedItemColor: secondaryColor,
                    items: cubit.navBarItems,
                    onTap: (index) {
                      cubit.changeNavBar(index);
                    },
                    currentIndex: cubit.currentIndex,
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: secondaryColor.withOpacity(0.7),
              onPressed: () {
                showModalBottomSheet(
                  isDismissible: false,
                  isScrollControlled: true,
                  backgroundColor: lightGrey,
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Add New Task',
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                      color: secondaryColor),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              defaultTextField(
                                controller: titleController,
                                labelText: 'task Title',
                                prefixIcon: Icons.title_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'title must not be empty';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              defaultTextField(
                                controller: descriptionController,
                                keyboardType: TextInputType.multiline,
                                labelText: 'task Description',
                                maxLines: 5,
                                prefixIcon: Icons.description_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'description must not be empty';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              defaultTextField(
                                  controller: timeController,
                                  keyboardType: TextInputType.datetime,
                                  labelText: 'task Time',
                                  prefixIcon: Icons.watch_later_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      initialEntryMode:
                                          TimePickerEntryMode.input,
                                    ).then((value) {
                                      if (value != null) {
                                        timeController.text =
                                            value.format(context).toString();
                                      } else {
                                        debugPrint(
                                            "time null************************************************************");
                                      }
                                    });
                                  }),
                              const SizedBox(
                                height: 15,
                              ),
                              defaultDropdownMenu(
                                width: MediaQuery.of(context).size.width * 0.7,
                                label: 'Task Category',
                                leadingIcon: Icons.category_outlined,
                                dropdownMenuEntries: List.generate(
                                  cubit.categoryList.length,
                                  (index) => DropdownMenuEntry(
                                    value:
                                        '${cubit.categoryList[index]['name']}',
                                    label:
                                        '${cubit.categoryList[index]['name']}',
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty
                                          .resolveWith((states) =>
                                              const EdgeInsetsDirectional.all(
                                                  15)),
                                    ),
                                  ),
                                ),
                                onSelected: (value) {
                                  int indexOfCategoryName = cubit
                                      .categoryNamesList
                                      .indexOf(value.toString());
                                  debugPrint(
                                      'indexOfCategoryName = $indexOfCategoryName');
                                  categoryId = cubit
                                      .categoryList[indexOfCategoryName]['id'];
                                  debugPrint('catId = $categoryId');
                                  category = value!;
                                  debugPrint(category);
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              defaultDropdownMenu(
                                width: MediaQuery.of(context).size.width * 0.7,
                                label: 'Task Priority',
                                leadingIcon: Icons.flag_outlined,
                                dropdownMenuEntries: List.generate(
                                  priorityList.length,
                                  (index) => DropdownMenuEntry(
                                    value: priorityList[index]['value'],
                                    label: priorityList[index]['value'],
                                    leadingIcon: Icon(
                                      Icons.flag_outlined,
                                      color: priorityList[index][Color],
                                    ),
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty
                                          .resolveWith((states) =>
                                              const EdgeInsetsDirectional.all(
                                                  15)),
                                    ),
                                  ),
                                ),
                                onSelected: (value) {
                                  priority = value!.toString();
                                  debugPrint(priority);
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Align(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: defaultButton(
                                  text: 'Add',
                                  onPressed: () {
                                    if (formKey.currentState != null &&
                                        formKey.currentState!.validate()) {
                                      if (isBottomSheetOpen == false) {
                                        setState(() {
                                          isBottomSheetOpen = true;
                                          // categoryNameController.clear();
                                        });
                                      } else {
                                        cubit.insertTask(
                                          taskModel: TaskModel(
                                            title: titleController.text,
                                            description:
                                                descriptionController.text,
                                            categoryId: categoryId,
                                            time: timeController.text,
                                            priority: priority,
                                            done: 0,
                                          ),
                                        );
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Icon(
                Icons.add,
              ),
            ),
            body: cubit.screen[cubit.currentIndex],
          ),
        );
      },
    );
  }
}
