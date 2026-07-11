import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import '../../../../employee/employee_home/controller/tasks/tasks_cubit.dart';
import '../atoms/taks_card.dart';
import '../molecules/my_tasks_loading_skeleton.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, 'Tasks'.tr()),
      body: SafeArea(
        child: BlocBuilder<EmployeeTasksCubit, EmployeeTasksState>(
          bloc: context.read<EmployeeTasksCubit>(),
          buildWhen: (previous, current) =>
              current is GetMyTasksLoading ||
              current is GetMyTasksSuccess ||
              current is GetMyTasksError,
          builder: (context, state) {
            if (state is GetMyTasksLoading) {
              return const MyTasksLoadingSkeleton();
            }

            if (state is GetMyTasksError) {
              return Center(child: Text(state.error));
            }

            if (state is GetMyTasksSuccess) {
              if (state.getTaskResponse.isEmpty) {
                return NoDataFound();
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                itemCount: state.getTaskResponse.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return ElasticInUp(
                    child: TaskCard(
                      task: state.getTaskResponse[index],
                    ),
                  );
                },
              );
            }
            return const MyTasksLoadingSkeleton();
          },
        ),
      ),
    );
  }
}
