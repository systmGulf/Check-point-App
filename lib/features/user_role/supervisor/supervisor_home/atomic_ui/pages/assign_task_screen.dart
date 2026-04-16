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
import '../molecules/assign_task_bloc_listener.dart';
import '../organism/assign_employee_for_task.dart';

class AssignTaskScreen extends StatefulWidget {
  const AssignTaskScreen({super.key, required this.taskId});
  final String taskId;
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
        appBar: buildCustomAppBar(context, 'Assign Task'.tr(context: context)),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const AssignEmployeesForTask(),
                verticalSpace(12),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Deadline',
                      style: AppStylesManger.font12RegularGrey),
                ),
                verticalSpace(8),
                CustomAppTextFormField(
                  hint: context.read<TasksCubit>().assignDeadline.isNotEmpty
                      ? context.read<TasksCubit>().assignDeadline
                      : 'Select date'.tr(context: context),
                  readOnly: true,
                  suffixIcon: SizedBox(
                      height: 24,
                      width: 24,
                      child: Center(
                          child: SvgPicture.asset('assets/images/calendar.svg'))),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        context.read<TasksCubit>().assignDeadline =
                            '${picked.toIso8601String()}Z';
                      });
                    }
                  },
                ),
                verticalSpace(12),
                DropdownButtonFormField<int>(
                  initialValue: context.read<TasksCubit>().assignPriority,
                  decoration: InputDecoration(
                    labelText: 'Priority'.tr(context: context),
                    border: const OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Low')),
                    DropdownMenuItem(value: 1, child: Text('Medium')),
                    DropdownMenuItem(value: 2, child: Text('High')),
                  ],
                  onChanged: (v) {
                    if (v != null) context.read<TasksCubit>().assignPriority = v;
                  },
                ),
                verticalSpace(12),
                DropdownButtonFormField<int>(
                  initialValue: context.read<TasksCubit>().assignState,
                  decoration: InputDecoration(
                    labelText: 'State',
                    border: const OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Pending')),
                    DropdownMenuItem(value: 1, child: Text('In Progress')),
                    DropdownMenuItem(value: 2, child: Text('Completed')),
                    DropdownMenuItem(value: 3, child: Text('On Hold')),
                    DropdownMenuItem(value: 4, child: Text('Cancelled')),
                  ],
                  onChanged: (v) {
                    if (v != null) context.read<TasksCubit>().assignState = v;
                  },
                ),
                verticalSpace(15),
                CustomAppButton(
                  textButton: 'Assign'.tr(context: context),
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
