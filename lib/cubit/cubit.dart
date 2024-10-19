import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teknosoft/cubit/states.dart';
import 'package:teknosoft/models/category_model.dart';
import 'package:teknosoft/models/task_model.dart';
import 'package:teknosoft/modules/category_screen.dart';
import 'package:teknosoft/modules/done_task_screen.dart';
import 'package:teknosoft/modules/tasks_screen.dart';
import 'package:teknosoft/shared/components/constants.dart';

import '../database/sqlit.dart';
import '../shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<BottomNavigationBarItem> navBarItems = [
    const BottomNavigationBarItem(
      label: 'Category',
      icon: Icon(
        Icons.category_outlined,
      ),
    ),
    const BottomNavigationBarItem(
      label: 'Tasks',
      icon: Icon(
        Icons.list_alt_outlined,
      ),
    ),
    const BottomNavigationBarItem(
      label: 'Done',
      icon: Icon(
        Icons.check_circle_outline_outlined,
      ),
    ),
  ];

  List<Widget> screen = [
    const CategoryScreen(),
    const TasksScreen(),
    const DoneTaskScreen(),
  ];

  int currentIndex = 0;

  void changeNavBar(int index) {
    currentIndex = index;
    emit(AppBottomNavBarState());
  }

  String backgroundImage = img2;

  void changeBackgroundImage(String image) {
    backgroundImage = image;
    CacheHelper.saveDate(key: 'backgroundImage', value: backgroundImage)
        .then((value) {
      emit(AppChangeBackgroundImage());
    });
  }

  Future<void> initializeBackgroundImage() async {
    String? savedImage = await CacheHelper.getData(key: 'backgroundImage');
    if (savedImage != null) {
      backgroundImage = savedImage;
      emit(AppChangeBackgroundImage());
    }
  }

  // Database
  // category table
  SqlDb? database = SqlDb();

  // initialize and create DB
  void createDatabase() async {
    await database!.db;
    emit(AppCreateDatabaseState());

    getCategory();
    getTask();
  }

  int? categoryId;
  void insertCategory({
    required CategoryModel categoryModel,
  }) async {
    try {
      categoryId = await database!.insertData('''
      INSERT INTO category(name) VALUES
      ("${categoryModel.name}")
      ''');
      emit(AppInsertCategoryState());
      debugPrint('insert category *********');
      debugPrint('categoryId $categoryId *********');
      getCategory();
    } catch (error) {
      debugPrint('error in insert category ${error.toString()}');
    }
  }

  List<Map> categoryList = [];
  List<String> categoryNamesList = [];

  void getCategory() async {
    categoryList = [];
    categoryNamesList = [];
    emit(AppLoadingGetCategoryState());
    (await database!.readData("SELECT * FROM category")).forEach((element) {
      categoryList.add(element);
      categoryNamesList.add(element['name']);
    });
    emit(AppGetCategoryState());
    print(categoryList);
  }

  void deleteCategory({
    required int id,
  }) async {
    await database!.deleteData('DELETE FROM category WHERE id = ?', [id]);
    emit(AppDeleteCategoryState());
    getCategory();
  }

  int countTasksCategory(int categoryId) {
    int count = 0;
    for (final task in newTaskList) {
      // Check if the task's category matches the filter category
      if (task['categoryId'] == categoryId) {
        count++;
      }
    }
    emit(AppGetCategoryTaskCountState());
    return count;
  }

  // ***********************************************
  // task table
  void insertTask({
    required TaskModel taskModel,
  }) async {
    try {
      int taskId = await database!.insertData('''
      INSERT INTO tasks(title, description, time, categoryId, priority, done) VALUES
      ("${taskModel.title}", "${taskModel.description}", "${taskModel.time}", "${taskModel.categoryId}", "${taskModel.priority}", "${taskModel.done}")
      ''');
      emit(AppInsertTaskState());
      debugPrint('insert task *********');
      debugPrint('taskId $taskId *********');
      getTask();
    } catch (error) {
      debugPrint('error in insert task ${error.toString()}');
    }
  }

  List<Map> newTaskList = [];
  List<Map> doneTaskList = [];

  void getTask() async {
    newTaskList = [];
    doneTaskList = [];
    emit(AppLoadingGetTaskState());
    (await database!.readData("SELECT * FROM tasks")).forEach((element) {
      if (element['done'] == 0) {
        newTaskList.add(element);
      } else {
        doneTaskList.add(element);
      }
    });
    emit(AppGetTaskState());
    print(newTaskList);
    print(doneTaskList);
  }

  void deleteTask({
    required int id,
  }) async {
    await database!.deleteData('DELETE FROM tasks WHERE id = ?', [id]);
    emit(AppDeleteTaskState());
    getTask();
  }

  void updateTask({
    required TaskModel taskModel,
    required int id,
  }) async {
    await database!.updateData(
      'UPDATE tasks SET title = ?, description = ?, time = ?, categoryId = ?, priority = ?, done = ? WHERE id = ?',
      [
        '${taskModel.title}',
        '${taskModel.description}',
        '${taskModel.time}',
        '${taskModel.categoryId}',
        '${taskModel.priority}',
        '${taskModel.done}',
        id
      ],
    );
    emit(AppUpdateTaskState());
    getTask();
  }

  void sortTasksByPriority() {
    newTaskList.sort((task1, task2) {
      final Map<String, int> priorityOrder = {
        'High Priority': 0,
        'Medium Priority': 1,
        'Low Priority': 2,
      };
      final int priority1 = priorityOrder[task1['priority']]!;
      final int priority2 = priorityOrder[task2['priority']]!;
      return priority1.compareTo(priority2);
    });
    emit(AppSortState());
    debugPrint(
        'sorted *******************************************************************');
  }

  List<Map> filteredTasks = [];
  List<Map> filterTasksByCategory(int categoryId) {
    filteredTasks = [];
    for (final task in newTaskList) {
      if (task['categoryId'] == categoryId) {
        filteredTasks.add(task);
      }
    }
    emit(AppFilterState());
    return filteredTasks;
  }

  bool isCategoryChosen = false;
  void chooseCategory() {
    isCategoryChosen = true;
    emit(AppChooseCategoryState());
  }
}
