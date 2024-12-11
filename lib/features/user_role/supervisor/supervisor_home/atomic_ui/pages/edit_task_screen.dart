import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/styles/colors.dart';
import '../molecules/assign_task_bloc_listener.dart';
import '../organism/assign_employee_for_task.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key, required this.taskId});
  final int taskId;
  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  @override
  void initState() {
    context.read<TasksCubit>().employeeIds = [];
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildCustomAppBar(context, 'Assign Task'.tr(context: context)),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AssignEmployeesForTask(),
                verticalSpace(15),
                CustomAppButton(
                  textButton: 'Assign',
                  onPressed: () {
                    context
                        .read<TasksCubit>()
                        .assignTasks(taskId: widget.taskId);
                  },
                  buttonColor: ColorsManger.primaryColor,
                ),
                AssignTaskBlocListener()
              ],
            ),
          ),
        )));
  }
}
