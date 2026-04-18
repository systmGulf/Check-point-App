import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import '../molecules/add_task_bloc_listener.dart';

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
