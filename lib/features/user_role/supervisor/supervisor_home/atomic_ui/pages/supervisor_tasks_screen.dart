import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/build_alart_message.dart';
import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import '../../contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../../contoller/tasks_cubit/tasks_cubit.dart';
import '../atoms/task_item.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().tasks = [];
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

  void _deleteTask(int index) {
    final taskId =
        int.parse(context.read<TasksCubit>().tasks[index].id.toString());
    buildAlertDialog(context,
        title: 'Delete Task'.tr(context: context),
        message: 'Are you sure you want to delete this Task?'
            .tr(context: context), onYes: () {
      context.pop();

      context.read<TasksCubit>().deleteTask(id: taskId).then((isSuccess) {
        try {
          setState(() {
            context.read<TasksCubit>().tasks.removeAt(index);
          });
        } catch (e) {
          buildSnackBar(
            context,
            customSnackBar: CustomSnackBar.error(
              message: 'Failed to delete task.'.tr(context: context),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsManger.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          context.pushName(Routes.supervisorAddTasksScreen).then((value) {
            context.read<TasksCubit>().getTasks();
          });
        },
      ),
      body: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state is GetTasksSuccess) {
            setState(() {
              context.read<TasksCubit>().tasks.clear();
              final newTasks = state.tasks.value!.data!;
              for (var newTask in newTasks) {
                if (!context
                    .read<TasksCubit>()
                    .tasks
                    .any((task) => task.id == newTask.id)) {
                  context.read<TasksCubit>().tasks.add(newTask);
                }
              }
              maxScrollExtent = !state.tasks.value!.hasNextPage!;
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
            return Skeletonizer(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (_, __) => TaskItem(
                  onSelected: (value) {},
                  employeeName: [],
                  onEdit: () {},
                  onDelete: () {},
                  tasks: context.read<TasksCubit>().tasks,
                  id: '1',
                  priority: 'Loading...',
                  state: 'Loading...',
                  title: 'Loading...',
                  description: 'Loading...',
                  date: '2023-12-12',
                ),
              ),
            );
          }
          if (state is GetTasksError) {
            return Center(child: Text(state.errorMessage));
          }
          if (state is GetTasksSuccess || state is GetTaskPaginationLoading) {
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
                          itemCount: context.read<TasksCubit>().tasks.length,
                          itemBuilder: (_, index) {
                            return TaskItem(
                              onSelected: (status) {
                                context.read<TasksCubit>().taskStatus = status;
                                context.read<TasksCubit>().changeTaskStatus(
                                    taskId: context
                                        .read<TasksCubit>()
                                        .tasks[index]
                                        .id!);
                              },
                              employeeName: context
                                  .read<TasksCubit>()
                                  .tasks[index]
                                  .employees!,
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
                                          taskId: context
                                              .read<TasksCubit>()
                                              .tasks[index]
                                              .id!,
                                        ),
                                      ),
                                    )).then((value) {
                                  context.read<TasksCubit>().getTasks();
                                });
                              },
                              onDelete: () => _deleteTask(index),
                              tasks: [],
                              id: context
                                  .read<TasksCubit>()
                                  .tasks[index]
                                  .id
                                  .toString(),
                              priority: context
                                      .read<TasksCubit>()
                                      .tasks[index]
                                      .priorityStatus ??
                                  '',
                              state: context
                                      .read<TasksCubit>()
                                      .tasks[index]
                                      .status ??
                                  '',
                              title: context
                                      .read<TasksCubit>()
                                      .tasks[index]
                                      .title ??
                                  '',
                              description: context
                                      .read<TasksCubit>()
                                      .tasks[index]
                                      .description ??
                                  '',
                              date: DateFormat('yyyy-MM-dd')
                                  .format(DateTime.parse(
                                context
                                        .read<TasksCubit>()
                                        .tasks[index]
                                        .dueDate ??
                                    '',
                              )),
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
