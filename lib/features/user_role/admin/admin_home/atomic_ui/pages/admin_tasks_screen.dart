import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/enums/task_status.dart';
import 'package:employee_mangement/core/widgets/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/task_model/get_task_response.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';
import 'package:employee_mangement/core/widgets/custom_loading_indicator.dart';

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
import '../../../../supervisor/supervisor_home/contoller/tasks_cubit/tasks_cubit.dart';
import '../../../../supervisor/supervisor_home/atomic_ui/atoms/task_item.dart';
import '../../../../supervisor/supervisor_home/atomic_ui/molecules/supervisor_tasks_loading_skeleton.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import 'admin_assign_task_screen.dart';

class AdminTasksScreen extends StatefulWidget {
  const AdminTasksScreen({super.key});

  @override
  State<AdminTasksScreen> createState() => _AdminTasksScreenState();
}

class _AdminTasksScreenState extends State<AdminTasksScreen> {
  final ScrollController _scrollController = ScrollController();
  int nextPageNumber = 1;
  bool isLoading = false;
  bool maxScrollExtent = false;
  String? selectedStatus;
  bool isLoadingDialogShowing = false;

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
        _scrollController.position.maxScrollExtent) {
      if (maxScrollExtent == false && isLoading == false) {
        isLoading = true;
        await context.read<TasksCubit>().getTasks(
              pageNumber: ++nextPageNumber,
            );
        isLoading = false;
      }
    }
  }

  void _deleteTask(GetTasData task) {
    final taskId = int.parse(task.id.toString());
    buildDeleteAlertDialog(context,
        title: 'Delete Task'.tr(),
        message: 'Are you sure you want to delete this Task?'.tr(), onYes: () {
      context.pop();

      context.read<TasksCubit>().deleteTask(id: taskId).then((isSuccess) {
        if (isSuccess == true) {
          try {
            setState(() {
              context.read<TasksCubit>().tasks.removeWhere(
                    (item) => item.id == task.id,
                  );
            });
          } catch (_) {}
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
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text('Tasks'.tr(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                  } else if (filterData['statusThree'] == true) {
                    selectedStatus = TaskStatus.Pending.name;
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
              context.pushName(Routes.adminAddTasksScreen).then((value) {
                context.read<TasksCubit>().getTasks();
              });
            },
          ),
        ],
      ),
      body: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state is DeleteTaskLoading) {
            if (!isLoadingDialogShowing) {
              isLoadingDialogShowing = true;
              customLoadingIndicator(context);
            }
          } else {
            if (isLoadingDialogShowing) {
              Navigator.pop(context); // Pop loading dialog
              isLoadingDialogShowing = false;
            }
          }

          if (state is DeleteTaskSuccess) {
            buildSnackBar(
              context,
              customSnackBar: CustomSnackBar.success(
                message: 'Task deleted successfully'.tr(),
              ),
            );
          } else if (state is DeleteTaskError) {
            buildSnackBar(
              context,
              customSnackBar: CustomSnackBar.error(
                message: state.errorMessage.tr(),
              ),
            );
          }

          if (state is GetTaskPaginationFailure) {
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(child: Icon(Icons.error, color: Colors.red, size: 40)),
                      verticalSpace(20),
                      Text(state.errorMessage)
                    ],
                  );
          }
          if (state is GetTasksSuccess || state is GetTaskPaginationLoading) {
            final allTasks = context.read<TasksCubit>().tasks;
            final tasks = _filterTasks(allTasks);
            return tasks.isEmpty
                ? const NoDataFound()
                : RefreshIndicator(
                    onRefresh: () => context.read<TasksCubit>().getTasks(),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
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
                                              create: (context) => getIt<EmployeeCubit>()
                                                ..getAllEmployees(pageNumber: 0, itemCount: 1000),
                                            ),
                                          ],
                                          child: AdminAssignTaskScreen(
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
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: ColorsManger.primaryColor),
                            ),
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
