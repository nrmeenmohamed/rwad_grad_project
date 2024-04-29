import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:teknosoft/cubit/states.dart';
import 'package:teknosoft/shared/components/fallback_container.dart';
import 'package:teknosoft/shared/components/show_message.dart';
import 'package:teknosoft/shared/styles/colors.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import '../cubit/cubit.dart';
import '../models/task_model.dart';
import '../shared/components/constants.dart';
import '../shared/components/default_button.dart';
import '../shared/components/default_dropdown_menu.dart';
import '../shared/components/default_text_field.dart';
import '../shared/components/dialog.dart';
import '../shared/components/show_menu_button.dart';
import '../shared/components/task_container.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();

  TextEditingController desController = TextEditingController();

  TextEditingController timeController = TextEditingController();

  String category = '';

  String priority = '';

  bool chooseCategory = false;

  @override
  void dispose() {
    titleController.dispose();
    desController.dispose();
    timeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {
        if (state is AppDeleteTaskState) {
          showMessage(context, message: 'Task Deleted');
        }
        if (state is AppUpdateTaskState) {
          showMessage(context, message: 'Task Updated');
        }
      },
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
            top: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // date now & sort, filter
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // date
                  Text(
                    DateFormat.yMMMMd().format(DateTime.now()),
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.sp,
                    ),
                  ),
                  const Spacer(
                    flex: 6,
                  ),
                  if (cubit.isCategoryChosen)
                    IconButton(
                      onPressed: () {
                        cubit.isCategoryChosen = false;
                        cubit.getTask();
                      },
                      icon: Icon(
                        Icons.refresh,
                        color: textColor,
                        size: 30,
                      ),
                    ),

                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      showMenuButton(
                        context,
                        position: RelativeRect.fromRect(
                          const Rect.fromLTWH(20, 0, 150, 0),
                          Offset.zero & MediaQuery.of(context).size,
                        ),
                        items: <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'Sort',
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.sort,
                                  //color: Colors.red,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Sort',
                                ),
                              ],
                            ),
                            onTap: () {
                              cubit.sortTasksByPriority();
                            },
                          ),
                          PopupMenuItem<String>(
                            value: 'Filter',
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.filter_list_outlined,
                                  //color: Colors.green,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Filter',
                                ),
                              ],
                            ),
                            onTap: () {
                              showMenuButton(
                                context,
                                items: [
                                  PopupMenuItem<String>(
                                    value: 'value',
                                    child: DropdownMenu(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      label: const Text('Choose Category'),
                                      dropdownMenuEntries: List.generate(
                                        cubit.categoryList.length,
                                        (index) => DropdownMenuEntry(
                                          value: cubit.categoryList[index]
                                              ['id'],
                                          label: cubit.categoryList[index]
                                              ['name'],
                                        ),
                                      ),
                                      onSelected: (value) {
                                        cubit.chooseCategory();
                                        cubit.filterTasksByCategory(value);
                                        print(chooseCategory);
                                        debugPrint(value);
                                        print(cubit.filteredTasks);
                                      },
                                    ),
                                  ),
                                ],
                                position: RelativeRect.fromRect(
                                  const Rect.fromLTWH(20, 0, 150, 0),
                                  Offset.zero & MediaQuery.of(context).size,
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                    icon: Icon(
                      Icons.more_horiz_outlined,
                      color: textColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 10,),

              // date
              Stack(
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
                      borderRadius: BorderRadius.circular(10.r),
                      color: backgroundColor,
                    ),
                    padding: const EdgeInsetsDirectional.all(8),
                    child: DatePicker(
                      DateTime.now(),
                      initialSelectedDate: DateTime.now(),
                      selectionColor: secondaryColor,
                      selectedTextColor: textColor,
                      dateTextStyle: TextStyle(
                        color: textColor,
                      ),
                      dayTextStyle: TextStyle(
                        color: textColor,
                      ),
                      monthTextStyle: TextStyle(
                        color: textColor,
                      ),
                      onDateChange: (date) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              // task list
              ConditionalBuilder(
                condition: cubit.newTaskList.isNotEmpty,
                builder: (BuildContext context) {
                  return Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        if (cubit.isCategoryChosen) {
                          return taskContainer(
                            context,
                            onLongPress: () {
                              showMenuButton(
                                context,
                                position: RelativeRect.fromRect(
                                  const Rect.fromLTWH(20, 300, 150, 200),
                                  Offset.zero & MediaQuery.of(context).size,
                                ),
                                items: <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'Delete',
                                    child: const Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Delete',
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      dialog(
                                        context,
                                        dialogType: DialogType.warning,
                                        title: 'Delete Task',
                                        btnOkText: 'delete',
                                        btnOkOnPress: () {
                                          cubit.deleteTask(
                                            id: cubit.newTaskList[index]['id'],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Edit',
                                    child: const Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Edit',
                                          ),
                                        ),
                                        //SizedBox(width: 5,),
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      titleController.text =
                                          cubit.newTaskList[index]['title'];
                                      desController.text = cubit
                                          .newTaskList[index]['description'];
                                      timeController.text =
                                          cubit.newTaskList[index]['time'];
                                      category = cubit.categoryNamesList[
                                          cubit.newTaskList[index]
                                                  ['categoryId'] -
                                              1];
                                      priority =
                                          cubit.newTaskList[index]['priority'];
                                      showModalBottomSheet(
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        'Edit Task',
                                                        style: TextStyle(
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                secondaryColor),
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height: 20,
                                                    ),

                                                    defaultTextField(
                                                      controller:
                                                          titleController,
                                                      labelText: 'task Title',
                                                      prefixIcon:
                                                          Icons.title_outlined,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    defaultTextField(
                                                      controller: desController,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      labelText:
                                                          'task Description',
                                                      maxLines: 5,
                                                      prefixIcon: Icons
                                                          .description_outlined,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    defaultTextField(
                                                        controller:
                                                            timeController,
                                                        keyboardType:
                                                            TextInputType
                                                                .datetime,
                                                        labelText: 'task Time',
                                                        prefixIcon: Icons
                                                            .watch_later_outlined,
                                                        onTap: () {
                                                          showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                TimeOfDay.now(),
                                                            initialEntryMode:
                                                                TimePickerEntryMode
                                                                    .input,
                                                          ).then((value) {
                                                            if (value != null) {
                                                              timeController
                                                                      .text =
                                                                  value
                                                                      .format(
                                                                          context)
                                                                      .toString();
                                                            } else {
                                                              debugPrint(
                                                                  "time null************************************************************");
                                                            }
                                                          });
                                                        }),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    // category

                                                    defaultDropdownMenu(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      label: 'Task Category',
                                                      leadingIcon: Icons
                                                          .category_outlined,
                                                      dropdownMenuEntries:
                                                          List.generate(
                                                        cubit.categoryList
                                                            .length,
                                                        (index) =>
                                                            DropdownMenuEntry(
                                                          value:
                                                              '${cubit.categoryList[index]['name']}',
                                                          label:
                                                              '${cubit.categoryList[index]['name']}',
                                                          style: ButtonStyle(
                                                            padding: MaterialStateProperty
                                                                .resolveWith(
                                                                    (states) =>
                                                                        const EdgeInsetsDirectional
                                                                            .all(
                                                                            15)),
                                                          ),
                                                        ),
                                                      ),
                                                      onSelected: (value) {
                                                        category = value!;
                                                        debugPrint(category);
                                                      },
                                                      initialSelection:
                                                          category,
                                                    ),

                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    // priority

                                                    defaultDropdownMenu(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      label: 'Task Priority',
                                                      leadingIcon:
                                                          Icons.flag_outlined,
                                                      dropdownMenuEntries:
                                                          List.generate(
                                                        priorityList.length,
                                                        (index) =>
                                                            DropdownMenuEntry(
                                                          value: priorityList[
                                                              index]['value'],
                                                          label: priorityList[
                                                              index]['value'],
                                                          leadingIcon: Icon(
                                                            Icons.flag_outlined,
                                                            color: priorityList[
                                                                index][Color],
                                                          ),
                                                          style: ButtonStyle(
                                                            padding: MaterialStateProperty
                                                                .resolveWith(
                                                                    (states) =>
                                                                        const EdgeInsetsDirectional
                                                                            .all(
                                                                            15)),
                                                          ),
                                                        ),
                                                      ),
                                                      onSelected: (value) {
                                                        priority =
                                                            value!.toString();
                                                        debugPrint(priority);
                                                      },
                                                      initialSelection:
                                                          priority,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .bottomEnd,
                                                      child: defaultButton(
                                                        text: 'Edit',
                                                        onPressed: () {
                                                          dialog(context,
                                                              dialogType:
                                                                  DialogType
                                                                      .question,
                                                              title:
                                                                  'Edit Task',
                                                              btnOkOnPress: () {
                                                            cubit.updateTask(
                                                              taskModel:
                                                                  TaskModel(
                                                                title:
                                                                    titleController
                                                                        .text,
                                                                description:
                                                                    desController
                                                                        .text,
                                                                time:
                                                                    timeController
                                                                        .text,
                                                                categoryId: cubit
                                                                            .newTaskList[
                                                                        index][
                                                                    'categoryId'],
                                                                priority:
                                                                    priority,
                                                                done: 0,
                                                              ),
                                                              id: cubit
                                                                      .newTaskList[
                                                                  index]['id'],
                                                            );
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            debugPrint(
                                                                'updated task ******************');
                                                          }, btnCancelOnPress:
                                                                  () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
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
                                  ),
                                ],
                              );
                            },
                            taskModel: cubit.filteredTasks[index],
                          );
                        } else {
                          return taskContainer(
                            context,
                            onLongPress: () {
                              showMenuButton(
                                context,
                                position: RelativeRect.fromRect(
                                  const Rect.fromLTWH(20, 300, 150, 200),
                                  Offset.zero & MediaQuery.of(context).size,
                                ),
                                items: <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'Delete',
                                    child: const Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Delete',
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      dialog(
                                        context,
                                        dialogType: DialogType.warning,
                                        title: 'Delete Task',
                                        btnOkText: 'delete',
                                        btnOkOnPress: () {
                                          cubit.deleteTask(
                                            id: cubit.newTaskList[index]['id'],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Edit',
                                    child: const Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Edit',
                                          ),
                                        ),
                                        //SizedBox(width: 5,),
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      titleController.text =
                                          cubit.newTaskList[index]['title'];
                                      desController.text = cubit
                                          .newTaskList[index]['description'];
                                      timeController.text =
                                          cubit.newTaskList[index]['time'];
                                      category = cubit.categoryNamesList[
                                          cubit.newTaskList[index]
                                                  ['categoryId'] -
                                              1];
                                      priority =
                                          cubit.newTaskList[index]['priority'];
                                      showModalBottomSheet(
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        'Edit Task',
                                                        style: TextStyle(
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                secondaryColor),
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height: 20,
                                                    ),

                                                    defaultTextField(
                                                      controller:
                                                          titleController,
                                                      labelText: 'task Title',
                                                      prefixIcon:
                                                          Icons.title_outlined,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    defaultTextField(
                                                      controller: desController,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      labelText:
                                                          'task Description',
                                                      maxLines: 5,
                                                      prefixIcon: Icons
                                                          .description_outlined,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    defaultTextField(
                                                        controller:
                                                            timeController,
                                                        keyboardType:
                                                            TextInputType
                                                                .datetime,
                                                        labelText: 'task Time',
                                                        prefixIcon: Icons
                                                            .watch_later_outlined,
                                                        onTap: () {
                                                          showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                TimeOfDay.now(),
                                                            initialEntryMode:
                                                                TimePickerEntryMode
                                                                    .input,
                                                          ).then((value) {
                                                            if (value != null) {
                                                              timeController
                                                                      .text =
                                                                  value
                                                                      .format(
                                                                          context)
                                                                      .toString();
                                                            } else {
                                                              debugPrint(
                                                                  "time null************************************************************");
                                                            }
                                                          });
                                                        }),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    // category
                                                    defaultDropdownMenu(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      label: 'Task Category',
                                                      leadingIcon: Icons
                                                          .category_outlined,
                                                      dropdownMenuEntries:
                                                          List.generate(
                                                        cubit.categoryList
                                                            .length,
                                                        (index) =>
                                                            DropdownMenuEntry(
                                                          value:
                                                              '${cubit.categoryList[index]['name']}',
                                                          label:
                                                              '${cubit.categoryList[index]['name']}',
                                                          style: ButtonStyle(
                                                            padding: MaterialStateProperty
                                                                .resolveWith(
                                                                    (states) =>
                                                                        const EdgeInsetsDirectional
                                                                            .all(
                                                                            15)),
                                                          ),
                                                        ),
                                                      ),
                                                      onSelected: (value) {
                                                        category = value!;
                                                        debugPrint(category);
                                                      },
                                                      initialSelection:
                                                          category,
                                                    ),

                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    // priority

                                                    defaultDropdownMenu(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      label: 'Task Priority',
                                                      leadingIcon:
                                                          Icons.flag_outlined,
                                                      dropdownMenuEntries:
                                                          List.generate(
                                                        priorityList.length,
                                                        (index) =>
                                                            DropdownMenuEntry(
                                                          value: priorityList[
                                                              index]['value'],
                                                          label: priorityList[
                                                              index]['value'],
                                                          leadingIcon: Icon(
                                                            Icons.flag_outlined,
                                                            color: priorityList[
                                                                index][Color],
                                                          ),
                                                          style: ButtonStyle(
                                                            padding: MaterialStateProperty
                                                                .resolveWith(
                                                                    (states) =>
                                                                        const EdgeInsetsDirectional
                                                                            .all(
                                                                            15)),
                                                          ),
                                                        ),
                                                      ),
                                                      onSelected: (value) {
                                                        priority =
                                                            value!.toString();
                                                        debugPrint(priority);
                                                      },
                                                      initialSelection:
                                                          priority,
                                                    ),

                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .bottomEnd,
                                                      child: defaultButton(
                                                        text: 'Edit',
                                                        onPressed: () {
                                                          dialog(context,
                                                              dialogType:
                                                                  DialogType
                                                                      .question,
                                                              title:
                                                                  'Edit Task',
                                                              btnOkOnPress: () {
                                                            cubit.updateTask(
                                                              taskModel:
                                                                  TaskModel(
                                                                title:
                                                                    titleController
                                                                        .text,
                                                                description:
                                                                    desController
                                                                        .text,
                                                                time:
                                                                    timeController
                                                                        .text,
                                                                categoryId: cubit
                                                                            .newTaskList[
                                                                        index][
                                                                    'categoryId'],
                                                                priority:
                                                                    priority,
                                                                done: 0,
                                                              ),
                                                              id: cubit
                                                                      .newTaskList[
                                                                  index]['id'],
                                                            );
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            debugPrint(
                                                                'updated task ******************');
                                                          });
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
                                  ),
                                ],
                              );
                            },
                            taskModel: cubit.newTaskList[index],
                          );
                        }
                      },
                      itemCount: cubit.isCategoryChosen
                          ? cubit.filteredTasks.length
                          : cubit.newTaskList.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        height: 8.h,
                      ),
                    ),
                  );
                },
                fallback: (BuildContext context) => fallbackContainer(
                  context,
                  text: 'Add New Task',
                  icon: Icons.library_books,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
