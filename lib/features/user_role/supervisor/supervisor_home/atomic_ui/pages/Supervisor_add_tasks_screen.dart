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
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import '../molecules/add_task_bloc_listener.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildCustomAppBar(context, 'Add New Task'.tr(context: context)),
        body: Padding(
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
                    child: Text('Task title'.tr(context: context),
                        style: AppStylesManger.font12RegularGrey),
                  ),
                  verticalSpace(12),
                  CustomAppTextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter title'.tr(context: context);
                        }
                        return null;
                      },
                      controller: context.read<TasksCubit>().titleController,
                      hint: 'Enter title here...'.tr(context: context)),
                  verticalSpace(12),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Task Description'.tr(context: context),
                        style: AppStylesManger.font12RegularGrey),
                  ),
                  verticalSpace(12),
                  CustomAppTextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter description'.tr(context: context);
                      }
                      return null;
                    },
                    controller:
                        context.read<TasksCubit>().descriptionController,
                    hint: 'Enter description here...'.tr(context: context),
                    maxLines: 5,
                  ),
                  verticalSpace(12),
                  SizedBox(
                    width: 331,
                    child: Text('Priority'.tr(context: context),
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
                    child: Text('Due date'.tr(context: context),
                        style: AppStylesManger.font12RegularGrey),
                  ),
                  verticalSpace(12),
                  CustomAppTextFormField(
                    hint: context.read<TasksCubit>().dueDate != ''
                        ? context.read<TasksCubit>().dueDate
                        : 'Select date'.tr(context: context),
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
                  CustomAppButton(
                    textButton: 'Add Task'.tr(context: context),
                    buttonColor: ColorsManger.primaryColor,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<TasksCubit>().addTask();
                      }
                    },
                  ),
                  AddTaskBlocListener(),
                ],
              ),
            ),
          ),
        ));
  }
}
