import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/core/notifications/notification_repo.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/task_model/add_task_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/task_model/get_task_response.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_tasks_repo/supervisor_tasks_repo.dart';

import '../../model/drop_down_item.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({
    required this.supervisorRepo,
    required this.notificationRepo,
  }) : super(TasksInitial());

  final SupervisorTasksRepo supervisorRepo;
  final NotificationRepo notificationRepo;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<DropdownItemModel> dropdownItems = [];
  final List<GetTasData> tasks = [];
  String priorityStatus = 'medium';
  String dueDate = '';
  String taskStatus = '';

  Future<void> addTask({
    String? title,
    String? description,
    String? dueDate,
    String? priorityStatus,
  }) async {
    emit(AddTaskLoading());
    final titleValue = title ?? titleController.text.trim();
    final descriptionValue = description ?? descriptionController.text.trim();
    final dueDateValue = dueDate ?? this.dueDate;
    final priorityValue = priorityStatus ?? this.priorityStatus;
    if (titleValue.isEmpty ||
        descriptionValue.isEmpty ||
        dueDateValue.isEmpty) {
      if (!isClosed) {
        emit(
          AddTaskError(errorMessage: 'supervisor.tasks.completeAllFields'),
        );
      }
      return;
    }
    final result = await supervisorRepo.addTask(
      addTaskRequestBody: AddTaskRequestBody(
        title: titleValue,
        description: descriptionValue,
        dueDate: dueDateValue,
        priorityStatus: priorityValue,
        status: 'Pending',
      ),
    );
    result.fold(
      (l) {
        if (!isClosed) emit(AddTaskError(errorMessage: l.message));
      },
      (r) {
        final createdTask = GetTasData(
          id: -DateTime.now().millisecondsSinceEpoch,
          title: titleValue,
          description: descriptionValue,
          dueDate: dueDateValue,
          priorityStatus: _normalizePriority(priorityValue),
          status: 'Pending',
          employees: const [],
        );
        if (!isClosed) emit(AddTaskSuccess(createdTask: createdTask));
        titleController.clear();
        descriptionController.clear();
        this.dueDate = '';
        this.priorityStatus = 'medium';
      },
    );
  }

  Future<void> getTasks({int pageNumber = 0}) async {
    if (pageNumber == 0) {
      emit(GetTasksLoading());
    } else {
      emit(GetTaskPaginationLoading());
    }
    final result = await supervisorRepo.getAllTasksByDepartmentId(
      pageNumber: pageNumber,
    );
    result.fold(
      (l) {
        if (isClosed) return;
        if (pageNumber == 0) {
          emit(GetTasksError(errorMessage: l.message));
        } else {
          emit(GetTaskPaginationFailure(errorMessage: l.message));
        }
      },
      (r) {
        if (pageNumber == 0) {
          tasks
            ..clear()
            ..addAll(r);
        } else {
          for (final task in r) {
            if (!tasks.any((existingTask) => existingTask.id == task.id)) {
              tasks.add(task);
            }
          }
        }
        if (!isClosed) emit(GetTasksSuccess(tasks: List.unmodifiable(tasks)));
      },
    );
  }

  String _normalizePriority(String priorityValue) {
    if (priorityValue.isEmpty) {
      return priorityValue;
    }
    return priorityValue[0].toUpperCase() + priorityValue.substring(1);
  }

  Future<void> deleteTask({required int id}) async {
    emit(DeleteTaskLoading());
    final result = await supervisorRepo.deleteTaskById(id: id);
    result.fold(
      (l) {
        if (!isClosed) emit(DeleteTaskError(errorMessage: l.message));
      },
      (r) {
        if (!isClosed) emit(DeleteTaskSuccess());
      },
    );
  }

  Future<void> assignTasks({
    required int taskId,
    List<DropdownItemModel>? employees,
  }) async {
    final selectedEmployees = employees ?? dropdownItems;
    emit(AssignTaskLoading());
    if (selectedEmployees.isEmpty) {
      emit(AssignTaskError(errorMessage: 'supervisor.tasks.selectEmployee'));
      return;
    }
    final result = await supervisorRepo.assignTask(
      employeeIds: selectedEmployees.map((e) => e.id).toList(),
      taskId: taskId,
    );
    result.fold(
      (l) {
        if (!isClosed) emit(AssignTaskError(errorMessage: l.message));
      },
      (r) {
        if (!isClosed) {
          _notifyEmployees(employees: selectedEmployees);
          dropdownItems.clear();
          emit(AssignTaskSuccess());
        }
      },
    );
  }

  Future<void> changeTaskStatus({
    required int taskId,
    String? taskStatus,
  }) async {
    final selectedTaskStatus = taskStatus ?? this.taskStatus;
    emit(ChangeTaskStatusLoading());
    final result = await supervisorRepo.changeTaskStatus(
      taskId: taskId,
      status: selectedTaskStatus,
    );
    result.fold(
      (l) {
        if (!isClosed) emit(ChangeTaskStatusError(errorMessage: l.message));
      },
      (r) {
        if (!isClosed) emit(ChangeTaskStatusSuccess());
        getTasks();
      },
    );
  }

  Future<void> deleteEmployeeFromTask({
    required int taskId,
    required String employeeIds,
  }) async {
    emit(RemoveEmployeeFromTaskLoading());
    final result = await supervisorRepo.removeSomeEmployeesFromTask(
      taskId: taskId,
      employeeIds: employeeIds,
    );
    result.fold(
      (l) {
        if (!isClosed) {
          emit(RemoveEmployeeFromTaskError(errorMessage: l.message));
        }
      },
      (r) {
        if (!isClosed) emit(RemoveEmployeeFromTaskSuccess());
        getTasks();
      },
    );
  }

  void _notifyEmployees({required List<DropdownItemModel> employees}) {
    for (final employee in employees) {
      for (final token in employee.employeesDeviceTokens) {
        notificationRepo.sendSingleNotification(
          title: 'Task Assign',
          body: 'You have been assigned a new task',
          token: token,
        );
      }
    }
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
