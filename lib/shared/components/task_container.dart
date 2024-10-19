import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../../models/task_model.dart';
import '../styles/colors.dart';

Widget taskContainer(
  context, {
  required Function onLongPress,
  required Map taskModel,
}) =>
    BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        bool valueBox = taskModel['done'] == 1;
        String categoryName = '';
        for (final category in cubit.categoryList) {
          if (category['id'] == taskModel['categoryId']) {
            categoryName = category['name'];
            break;
          }
        }
        return GestureDetector(
          onLongPress: () {
            onLongPress();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: backgroundColor,
            ),
            child: ListTile(
              title: Text(
                taskModel['title'],
                style: TextStyle(
                  color: textColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskModel['description'],
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        categoryName,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Text(
                        taskModel['time'],
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Checkbox(
                side: BorderSide(
                  color: choosePriorityColor(
                      priorityStates: taskModel['priority']),
                ),
                onChanged: (bool? value) {
                  final Map modifiedTaskModel = {...taskModel}; // Make a copy
                  final int doneStatus = value != null && value ? 1 : 0;
                  modifiedTaskModel['done'] = doneStatus; // Modify the copy
                  cubit.updateTask(
                    taskModel: TaskModel(
                      title: taskModel['title'],
                      description: taskModel['description'],
                      time: taskModel['time'],
                      categoryId: taskModel['categoryId'],
                      priority: taskModel['priority'],
                      done: doneStatus,
                    ),
                    id: taskModel['id'],
                  );
                },
                value: valueBox,
                activeColor: secondaryColor,
              ),
            ),
          ),
        );
      },
    );

Color choosePriorityColor({
  required String priorityStates,
}) {
  Color color = Colors.transparent;
  switch (priorityStates) {
    case 'High Priority':
      color = Colors.red;
      break;
    case 'Medium Priority':
      color = Colors.yellow;
      break;
    case 'Low Priority':
      color = Colors.blue;
      break;
  }
  return color;
}
