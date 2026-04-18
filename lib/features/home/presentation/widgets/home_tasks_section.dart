import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/animations/animations.dart';
import 'package:employee_mangement/core/style/app_text_style.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/molecules/employee_home_section_item.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/tasks/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeTasksSection extends StatelessWidget {
  const HomeTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedByWidgetType(
      widgetType: WidgetAnimationType.card,
      delayDuration: const Duration(milliseconds: 400),
      child: BlocBuilder<EmployeeTasksCubit, EmployeeTasksState>(
        buildWhen: (previous, current) =>
            current is GetMyTasksError ||
            current is GetMyTasksSuccess ||
            current is GetMyTasksLoading,
        builder: (context, state) {
          if (state is GetMyTasksError) {
            return Text(
              state.error,
              style: AppTextStyle.body12,
            );
          }

          if (state is GetMyTasksSuccess) {
            return EmployeeHomeSectionItem(
              getTaskResponse: state.getTaskResponse,
              title: 'New tasks today'.tr(context: context),
              content:
                  'No Alert available for today. Please check back again tomorrow.'
                      .tr(context: context),
            );
          }

          return Skeletonizer(
            child: EmployeeHomeSectionItem(
              getTaskResponse: const [],
              title: 'Data Loading'.tr(context: context),
              content:
                  'No Alert available for today. Please check back again tomorrow.'
                      .tr(context: context),
            ),
          );
        },
      ),
    );
  }
}
