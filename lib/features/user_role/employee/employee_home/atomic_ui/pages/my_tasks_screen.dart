import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import '../../controller/tasks/tasks_cubit.dart';
import '../atoms/my_tasks_item.dart';

class MyTasksScreen extends StatelessWidget {
  const MyTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        'My Tasks'.tr(context: context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
        ),
        child: BlocBuilder<EmployeeTasksCubit, EmployeeTasksState>(
          buildWhen: (previous, current) =>
              current is GetMyTasksError ||
              current is GetMyTasksSuccess ||
              current is GetMyTasksLoading,
          builder: (context, state) {
            if (state is GetMyTasksError) {
              return Text(state.error);
            }
            if (state is GetMyTasksSuccess) {
              return state.getTaskResponse.isEmpty
                  ? NoDataFound()
                  : ListView.builder(
                      itemCount: state.getTaskResponse.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: MyTaskItem(
                            onSelected: (value) {
                              context.read<EmployeeTasksCubit>().taskStatus =
                                  value;
                              context
                                  .read<EmployeeTasksCubit>()
                                  .updateTaskStatus(
                                      taskId:
                                          state.getTaskResponse[index].id ?? 0);
                            },
                            date: DateFormat('yyyy-MM-dd').format(
                                DateTime.parse(
                                    state.getTaskResponse[index].dueDate ??
                                        '')),
                            des: state.getTaskResponse[index].description ?? '',
                            priority:
                                state.getTaskResponse[index].priorityStatus ??
                                    '',
                            status: state.getTaskResponse[index].status ?? '',
                            title: state.getTaskResponse[index].title ?? '',
                          ),
                        );
                      });
            }
            return Center(
                child: Skeletonizer(
                    child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: MyTaskItem(
                              onSelected: (value) {},
                              date: DateFormat('yyyy-MM-dd')
                                  .format(DateTime.parse('2023-01-01')),
                              des: 'Data load',
                              priority: 'Data load',
                              status: 'Data load',
                              title: 'Data load',
                            ),
                          );
                        })));
          },
        ),
      ),
    );
  }
}
