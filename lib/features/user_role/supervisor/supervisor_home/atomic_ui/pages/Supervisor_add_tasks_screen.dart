import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import '../molecules/add_task_bloc_listener.dart';
import '../molecules/assign_task_bloc_listener.dart';
import '../organism/assign_employee_for_task.dart';
import '../molecules/priority_widget.dart';

class SupervisorAddTasksScreen extends StatefulWidget {
  const SupervisorAddTasksScreen({super.key});

  @override
  State<SupervisorAddTasksScreen> createState() =>
      _SupervisorAddTasksScreenState();
}

class _SupervisorAddTasksScreenState extends State<SupervisorAddTasksScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().dropdownItems.clear();
    context.read<TasksCubit>().titleController.clear();
    context.read<TasksCubit>().descriptionController.clear();
    context.read<TasksCubit>().dueDate = '';
    context.read<TasksCubit>().priorityStatus = 'low';
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = EasyLocalization.of(context)?.currentLocale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Add New Task'.tr(),
          style: TextStyle(
            color: const Color(0xFF1F2937),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isRTL ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left,
                  color: const Color(0xFF4B5563),
                  size: 24.sp,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task Title Label
                Text(
                  'Task title'.tr(),
                  style: TextStyle(
                    color: const Color(0xFF1F2937),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalSpace(8),
                // Task Title TextField
                TextFormField(
                  controller: context.read<TasksCubit>().titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter title'.tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    hintText: 'Enter title here...'.tr(),
                    hintStyle: TextStyle(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 13.sp,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide(color: ColorsManger.primaryColor, width: 1.5),
                    ),
                  ),
                ),
                verticalSpace(16),

                // Task Description Label
                Text(
                  'Task Description'.tr(),
                  style: TextStyle(
                    color: const Color(0xFF1F2937),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalSpace(8),
                // Task Description TextField
                TextFormField(
                  controller: context.read<TasksCubit>().descriptionController,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter description'.tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    hintText: 'Enter description here...'.tr(),
                    hintStyle: TextStyle(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 13.sp,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide(color: ColorsManger.primaryColor, width: 1.5),
                    ),
                  ),
                ),
                verticalSpace(16),

                // Priority Label
                Text(
                  'Priority'.tr(),
                  style: TextStyle(
                    color: const Color(0xFF1F2937),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalSpace(8),
                priorityWidget(
                  onChanged: (priority) {
                    if (priority != null) {
                      context.read<TasksCubit>().priorityStatus = priority;
                      log("Selected priority: $priority");
                    }
                  },
                ),
                verticalSpace(16),

                // Due Date Label
                Text(
                  'Due date'.tr(),
                  style: TextStyle(
                    color: const Color(0xFF1F2937),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalSpace(8),
                // Due Date Picker Field
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          String formattedDate = DateFormat('yyyy-MM-dd', 'en').format(value);
                          context.read<TasksCubit>().dueDate = formattedDate;
                        });
                      }
                    });
                  },
                  child: Container(
                    height: 48.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          color: const Color(0xFF9CA3AF),
                          size: 18.sp,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          context.read<TasksCubit>().dueDate != ''
                              ? context.read<TasksCubit>().dueDate
                              : 'Select date'.tr(),
                          style: TextStyle(
                            color: context.read<TasksCubit>().dueDate != ''
                                ? const Color(0xFF1F2937)
                                : const Color(0xFF9CA3AF),
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(16),

                // Assign Employees Label
                Text(
                  'Assign Employees'.tr(),
                  style: TextStyle(
                    color: const Color(0xFF1F2937),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalSpace(8),
                const AssignEmployeesForTask(),
                verticalSpace(24),

                // Add Task Button
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<TasksCubit>().addTask();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManger.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Add Task'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const AddTaskBlocListener(),
                const AssignTaskBlocListener(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
