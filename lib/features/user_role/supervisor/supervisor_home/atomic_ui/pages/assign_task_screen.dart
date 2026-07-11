import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import '../molecules/assign_task_bloc_listener.dart';
import '../organism/assign_employee_for_task.dart';

class AssignTaskScreen extends StatefulWidget {
  const AssignTaskScreen({super.key, required this.taskId});
  final int taskId;
  @override
  State<AssignTaskScreen> createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildCustomAppBar(context, 'Assign Task'.tr()),
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
                  textButton: 'Assign'.tr(),
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
