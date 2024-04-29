import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:teknosoft/cubit/cubit.dart';
import 'package:teknosoft/cubit/states.dart';
import 'package:teknosoft/shared/components/fallback_container.dart';

import '../shared/components/dialog.dart';
import '../shared/components/done_task_container.dart';
import '../shared/components/show_menu_button.dart';

class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ConditionalBuilder(
            condition: cubit.doneTaskList.isNotEmpty,
            builder: (BuildContext context) {
              return GridView.custom(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverWovenGridDelegate.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  pattern: [
                    const WovenGridTile(1),
                    const WovenGridTile(
                      3 / 4,
                      crossAxisRatio: 0.9,
                      alignment: AlignmentDirectional.centerEnd,
                    ),
                  ],
                ),
                childrenDelegate: SliverChildBuilderDelegate(
                  childCount: cubit.doneTaskList.length,
                  (context, index) => doneTaskContainer(
                    taskModel: cubit.doneTaskList[index],
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
                                    id: cubit.doneTaskList[index]['id'],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
            fallback: (BuildContext context) => fallbackContainer(
              context,
              text: 'No Done Task Yet',
              icon: Icons.check_circle,
            ),
          ),
        );
      },
    );
  }
}
