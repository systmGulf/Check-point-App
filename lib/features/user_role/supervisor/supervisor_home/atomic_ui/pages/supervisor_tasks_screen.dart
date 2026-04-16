import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/task_model/get_task_response.dart';

import '../../../../../../core/common/show_menu_position.dart';
import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import '../pages/supervisor_tasks_loading_skeleton.dart';
import 'assign_task_screen.dart';

class SupervisorTasksScreen extends StatefulWidget {
  const SupervisorTasksScreen({super.key});

  @override
  State<SupervisorTasksScreen> createState() => _SupervisorTasksScreenState();
}

class _SupervisorTasksScreenState extends State<SupervisorTasksScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          CustomFloatingActionButton(
            text: 'Add Task'.tr(context: context),
            onTap: () {
              context.pushName(Routes.supervisorAddTasksScreen).then((value) {
                context.read<TasksCubit>().getTasks();
              });
            },
          ),
        ],
      ),
      body: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state is DeleteTaskSuccess) {
            context.read<TasksCubit>().getTasks();
          }
        },
        buildWhen: (previous, current) =>
            current is GetTasksLoading ||
            current is GetTasksSuccess ||
            current is GetTasksError ||
            current is DeleteTaskSuccess ||
            current is DeleteTaskLoading ||
            current is DeleteTaskError,
        builder: (context, state) {
          if (state is GetTasksLoading || state is DeleteTaskLoading) {
            return const SupervisorTasksLoadingSkeleton();
          }
          if (state is GetTasksError) {
            return state.errorMessage == 'Please check your internet connection'
                ? NoInternetConnectionWidget(onPressed: () {
                    context.read<TasksCubit>().getTasks();
                  })
                : Column(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(height: 20),
                      Text(state.errorMessage)
                    ],
                  );
          }
          if (state is DeleteTaskError) {
            return Center(child: Text(state.errorMessage));
          }
          if (state is GetTasksSuccess) {
            return state.tasks.isEmpty
                ? const NoDataFound()
                : RefreshIndicator(
                    onRefresh: () => context.read<TasksCubit>().getTasks(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      itemCount: state.tasks.length,
                      itemBuilder: (_, index) {
                        final task = state.tasks[index];
                        return BounceInUp(child: _TaskListCard(task: task));
                      },
                    ),
                  );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _TaskListCard extends StatelessWidget {
  const _TaskListCard({required this.task});

  final GetTasData task;

  void _openAssignScreen(BuildContext context) {
    if ((task.id ?? '').isEmpty) return;
    context.read<TasksCubit>().selectedEmployeeId = '';
    context.read<TasksCubit>().selectedEmployeeTokens = [];
    context.read<TasksCubit>().assignDeadline = '';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: context.read<TasksCubit>(),
            ),
            BlocProvider(
              create: (context) =>
                  getIt<GetEmployeesDataCubit>()..getEmployeesByDepartmentId(),
            ),
          ],
          child: AssignTaskScreen(taskId: task.id!),
        ),
      ),
    );
  }

  Future<void> _onActionPressed(BuildContext context) async {
    final selected = await showMenu<String>(
      context: context,
      position: showMenuPosition(context: context),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      items: [
        const PopupMenuItem<String>(
          value: 'assign',
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
              'من سيعمل عليها',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'حذف',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );

    if (selected == 'assign') {
      _openAssignScreen(context);
    } else if (selected == 'delete') {
      if ((task.id ?? '').isEmpty) return;
      context.read<TasksCubit>().deleteTask(id: task.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Title : ${task.title ?? '--'}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              Builder(
                builder: (iconContext) => InkWell(
                  onTap: () => _onActionPressed(iconContext),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.more_vert),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Text(
          //   '${'Code'.tr(context: context)}: ${task.code ?? '--'}',
          //   style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          // ),
          const SizedBox(height: 6),
          Text(
            task.description ?? '--',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}
