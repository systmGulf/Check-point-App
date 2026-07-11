import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/enums/task_status.dart';
import 'package:employee_mangement/core/widgets/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/task_model/get_task_response.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/build_alart_message.dart';
import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../../../../../core/widgets/custom_filter_container.dart';
import '../../../../../../core/widgets/custom_filter_floating_action_button.dart';
import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import '../atoms/task_item.dart';
import '../molecules/supervisor_tasks_loading_skeleton.dart';
import 'assign_task_screen.dart';

class SupervisorTasksScreen extends StatefulWidget {
  const SupervisorTasksScreen({super.key});

  @override
  State<SupervisorTasksScreen> createState() => _SupervisorTasksScreenState();
}

class _SupervisorTasksScreenState extends State<SupervisorTasksScreen> {
  final ScrollController _scrollController = ScrollController();
  int nextPageNumber = 1;
  bool isLoading = false;
  bool maxScrollExtent = false;
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().tasks.clear();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.7 &&
        !isLoading &&
        !maxScrollExtent) {
      setState(() {
        isLoading = true;
      });
      await context.read<TasksCubit>().getTasks(pageNumber: nextPageNumber++);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _deleteTask(GetTasData task) {
    final taskId = int.parse(task.id.toString());
    buildDeleteAlertDialog(context,
        title: 'Delete Task'.tr(),
        message: 'Are you sure you want to delete this Task?'
            .tr(), onYes: () {
      context.pop();

      context.read<TasksCubit>().deleteTask(id: taskId).then((isSuccess) {
        try {
          setState(() {
            context.read<TasksCubit>().tasks.removeWhere(
                  (item) => item.id == task.id,
                );
          });
        } catch (e) {
          buildSnackBar(
            context,
            customSnackBar: CustomSnackBar.error(
              message: 'Failed to delete task.'.tr(),
            ),
          );
        }
      });
    });
  }

  List<GetTasData> _filterTasks(List<GetTasData> tasks) {
    return tasks.where((task) {
      final matchesStatus = selectedStatus == null ||
          (task.status?.toLowerCase() == selectedStatus!.toLowerCase());

      return matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          CustomFilterFloatingActionButton(
            onPressed: () async {
              final filterData =
                  await showModalBottomSheet<Map<String, dynamic>>(
                backgroundColor: Colors.white,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                context: context,
                builder: (ctx) {
                  return CustomFilterContainer(
                    statusOne: "InProgress".tr(
                      context: context,
                    ),
                    statusTwo: "Done".tr(
                      context: context,
                    ),
                    statusThree: "Pending".tr(
                      context: context,
                    ),
                  );
                },
              );

              if (filterData != null) {
                setState(() {
                  if (filterData['statusOne'] == true) {
                    selectedStatus = TaskStatus.InProgress.name;
                  } else if (filterData['statusTwo'] == true) {
                    selectedStatus = TaskStatus.Done.name;
                    ;
                  } else if (filterData['statusThree'] == true) {
                    selectedStatus = TaskStatus.Pending.name;
                    ;
                  } else {
                    selectedStatus = null;
                  }
                });
              }
            },
          ),
          CustomFloatingActionButton(
            text: 'Add Task'.tr(),
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
          if (state is GetTasksSuccess) {
            setState(() {
              context.read<TasksCubit>().tasks.clear();
              final newTasks = state.tasks;
              for (var newTask in newTasks) {
                if (!context
                    .read<TasksCubit>()
                    .tasks
                    .any((task) => task.id == newTask.id)) {
                  context.read<TasksCubit>().tasks.add(newTask);
                }
              }
            });
          } else if (state is GetTaskPaginationFailure) {
            buildSnackBar(
              context,
              customSnackBar: CustomSnackBar.error(
                message: state.errorMessage,
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            current is GetTasksLoading ||
            current is GetTasksError ||
            current is GetTasksSuccess ||
            current is GetTaskPaginationLoading,
        builder: (context, state) {
          if (state is GetTasksLoading) {
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
                      verticalSpace(20),
                      Text(state.errorMessage)
                    ],
                  );
          }
          if (state is GetTasksSuccess || state is GetTaskPaginationLoading) {
            final allTasks = context.read<TasksCubit>().tasks;
            final tasks = _filterTasks(allTasks);
            return context.read<TasksCubit>().tasks.isEmpty
                ? const NoDataFound()
                : RefreshIndicator(
                    onRefresh: () => context.read<TasksCubit>().getTasks(),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tasks.length,
                          itemBuilder: (_, index) {
                            final currentTask = tasks[index];
                            return BounceInUp(
                              child: TaskItem(
                                onSelected: (status) {
                                  context.read<TasksCubit>().taskStatus =
                                      status;
                                  context.read<TasksCubit>().changeTaskStatus(
                                        taskId: currentTask.id!,
                                      );
                                },
                                employeeName: currentTask.employees ?? [],
                                onEdit: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider.value(
                                              value: context.read<TasksCubit>(),
                                            ),
                                            BlocProvider(
                                              create: (context) => getIt<
                                                  GetEmployeesDataCubit>()
                                                ..getEmployeesByDepartmentId(),
                                            ),
                                          ],
                                          child: AssignTaskScreen(
                                            taskId: currentTask.id!,
                                          ),
                                        ),
                                      )).then((value) {
                                    context.read<TasksCubit>().getTasks();
                                  });
                                },
                                onDelete: () => _deleteTask(currentTask),
                                tasks: [],
                                id: currentTask.id.toString(),
                                priority: currentTask.priorityStatus ?? '',
                                state: currentTask.status ?? '',
                                title: currentTask.title ?? '',
                                description: currentTask.description ?? '',
                                date: currentTask.dueDate ?? '',
                              ),
                            );
                          },
                        ),
                        if (state is GetTaskPaginationLoading &&
                            !maxScrollExtent)
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                                color: ColorsManger.primaryColor),
                          ),
                      ],
                    ),
                  );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
