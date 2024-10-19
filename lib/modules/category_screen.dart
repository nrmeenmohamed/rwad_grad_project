import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teknosoft/cubit/cubit.dart';
import 'package:teknosoft/cubit/states.dart';
import 'package:teknosoft/models/category_model.dart';

import '../shared/components/category_container.dart';
import '../shared/components/constants.dart';
import '../shared/components/default_button.dart';
import '../shared/components/default_text_field.dart';
import '../shared/components/dialog.dart';
import '../shared/components/show_menu_button.dart';
import '../shared/components/show_message.dart';
import '../shared/styles/colors.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController categoryNameController = TextEditingController();

  bool isBottomSheetOpen = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {
        if (state is AppDeleteCategoryState) {
          showMessage(context, message: 'Category Deleted');
        }
      },
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.63,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == cubit.categoryList.length) {
                      // Display the fixed container as the last item
                      return GestureDetector(
                        onTap: () {
                          categoryNameController.clear();
                          showModalBottomSheet(
                            backgroundColor: lightGrey,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return SingleChildScrollView(
                                reverse:
                                    true, // Start scrolling from the bottom
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              'Add New Category',
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w500,
                                                color: secondaryColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          defaultTextField(
                                            controller: categoryNameController,
                                            labelText: 'Category Name',
                                            prefixIcon: Icons.title_outlined,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'name must not be empty';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional.bottomEnd,
                                            child: defaultButton(
                                              text: 'Add',
                                              onPressed: () {
                                                if (formKey.currentState !=
                                                        null &&
                                                    formKey.currentState!
                                                        .validate()) {
                                                  if (isBottomSheetOpen ==
                                                      false) {
                                                    setState(() {
                                                      isBottomSheetOpen = true;
                                                    });
                                                  } else {
                                                    cubit.insertCategory(
                                                      categoryModel:
                                                          CategoryModel(
                                                        categoryId:
                                                            cubit.categoryId,
                                                        name:
                                                            categoryNameController
                                                                .text,
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
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(45.r),
                              topLeft: Radius.circular(15.r),
                              bottomRight: Radius.circular(15.r),
                              bottomLeft: Radius.circular(15.r),
                            ),
                            color: backgroundColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: CachedNetworkImageProvider(
                                  addCategoryImg,
                                  scale: 5.0,
                                ),
                              ),
                              Text(
                                'Add category',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      // Display other items in the GridView
                      return categoryContainer(
                        categoryModel: cubit.categoryList[index],
                        count: cubit.countTasksCategory(
                            cubit.categoryList[index]['id']),
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
                                  dialog(context,
                                      dialogType: DialogType.warning,
                                      title: 'Delete Task',
                                      btnOkText: 'delete', btnOkOnPress: () {
                                    cubit.deleteCategory(
                                      id: cubit.categoryList[index]['id'],
                                    );
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemCount: cubit.categoryList.length + 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
