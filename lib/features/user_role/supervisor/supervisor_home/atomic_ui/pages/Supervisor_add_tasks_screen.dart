import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../../../../../core/widgets/app_top_snack_bar.dart';
import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import '../molecules/priority_widget.dart';
import '../organism/assign_employee_for_task.dart';

class SupervisorAddTasksScreen extends StatefulWidget {
  const SupervisorAddTasksScreen({super.key});

  @override
  State<SupervisorAddTasksScreen> createState() =>
      _SupervisorAddTasksScreenState();
}

class _SupervisorAddTasksScreenState extends State<SupervisorAddTasksScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoadingDialogShowing = false;

  @override
  void initState() {
    super.initState();
    // Clear any previous selection when entering the screen
    context.read<TasksCubit>().dropdownItems.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: buildCustomAppBar(context, 'Add New Task'.tr()),
        body: BlocListener<TasksCubit, TasksState>(
          listenWhen: (previous, current) =>
              current is AddTaskLoading ||
              current is AssignTaskLoading ||
              current is AddTaskError ||
              current is AddTaskSuccess,
          listener: (context, state) {
            if (state is AddTaskLoading || state is AssignTaskLoading) {
              if (!isLoadingDialogShowing) {
                isLoadingDialogShowing = true;
                customLoadingIndicator(context);
              }
            } else {
              if (isLoadingDialogShowing) {
                Navigator.pop(context); // Pop loading dialog
                isLoadingDialogShowing = false;
              }
              if (state is AddTaskSuccess) {
                buildSnackBar(
                  context,
                  customSnackBar: CustomSnackBar.success(
                    message: "Task created and assigned successfully".tr(),
                  ),
                );
                Navigator.pop(context, state.createdTask);
              } else if (state is AddTaskError) {
                buildSnackBar(
                  context,
                  customSnackBar: CustomSnackBar.error(
                    message: state.errorMessage.tr(),
                  ),
                );
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('Task title'.tr(),
                          style: AppStylesManger.font12RegularGrey),
                    ),
                    verticalSpace(12),
                    CustomAppTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter title'.tr();
                          }
                          return null;
                        },
                        controller: context.read<TasksCubit>().titleController,
                        hint: 'Enter title here...'.tr()),
                    verticalSpace(12),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('Task Description'.tr(),
                          style: AppStylesManger.font12RegularGrey),
                    ),
                    verticalSpace(12),
                    CustomAppTextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter description'.tr();
                        }
                        return null;
                      },
                      controller:
                          context.read<TasksCubit>().descriptionController,
                      hint: 'Enter description here...'.tr(),
                      maxLines: 5,
                    ),
                    verticalSpace(12),
                    SizedBox(
                      width: 331,
                      child: Text('Priority'.tr(),
                          style: AppStylesManger.font12RegularGrey),
                    ),
                    verticalSpace(16),
                    priorityWidget(
                      onChanged: (prioity) {
                        setState(() {
                          context.read<TasksCubit>().priorityStatus = prioity!;
                          log(prioity);
                        });
                      },
                    ),
                    verticalSpace(12),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('Due date'.tr(),
                          style: AppStylesManger.font12RegularGrey),
                    ),
                    verticalSpace(12),
                    CustomAppTextFormField(
                      hint: context.read<TasksCubit>().dueDate != ''
                          ? context.read<TasksCubit>().dueDate
                          : 'Select date'.tr(),
                      readOnly: true,
                      hintStyle: const TextStyle(
                        color: Color(0xFF7F7F7F),
                        fontSize: 14,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        height: 0.10,
                        letterSpacing: 0.20,
                      ),
                      suffixIcon: SizedBox(
                          height: 24,
                          width: 24,
                          child: Center(
                              child: SvgPicture.asset(
                                  'assets/images/calendar.svg'))),
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd', 'en').format(value);
                              context.read<TasksCubit>().dueDate = formattedDate;
                            });
                          }
                        });
                      },
                    ),
                    verticalSpace(12),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('Assign Task To'.tr(),
                          style: AppStylesManger.font12RegularGrey),
                    ),
                    verticalSpace(12),
                    const AssignEmployeesForTask(),
                    verticalSpace(24),
                    CustomAppButton(
                      textButton: 'Add Task'.tr(),
                      buttonColor: ColorsManger.primaryColor,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final cubit = context.read<TasksCubit>();
                          if (cubit.dueDate.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select a due date'.tr())),
                            );
                            return;
                          }
                          if (cubit.dropdownItems.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select at least one employee to assign'.tr())),
                            );
                            return;
                          }
                          cubit.addAndAssignTask(
                            title: cubit.titleController.text.trim(),
                            description: cubit.descriptionController.text.trim(),
                            dueDate: cubit.dueDate,
                            priorityStatus: cubit.priorityStatus,
                            assignees: cubit.dropdownItems,
                          );
                        }
                      },
                    ),
                    verticalSpace(30),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
