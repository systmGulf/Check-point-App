import 'package:bloc/bloc.dart';
import 'package:employee_mangement/core/dependency%D9%80injection/register%D9%80factory.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/core/notifications/notification_repo.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/task_model/add_task_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/task_model/get_task_response.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_tasks_repo/supervisor_tasks_repo.dart';

import '../../model/drop_down_item.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final SupervisorTasksRepo supervisorRepo;
  TasksCubit(this.supervisorRepo) : super(TasksInitial());
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String assignDeadline = '';
  // Backward-compatible alias for old references.
  String get assignDeadLine => assignDeadline;
  set assignDeadLine(String value) => assignDeadline = value;
  int assignPriority = 0;
  int assignState = 0;
  String selectedEmployeeId = '';
  List<String> selectedEmployeeTokens = [];
  // Backward-compatible field used by existing priority UI.
  String priorityStatus = 'high';
  String taskStatus = 'Pending';
  List<DropdownItemModel> dropdownItems = [];
  List<GetTasData> tasks = [];
  Future<void> addTask() async {
    emit(AddTaskLoading());
    if (titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty) {
      final result = await supervisorRepo.addTask(
        addTaskRequestBody: AddTaskRequestBody(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
        ),
      );
      result.fold((l) {
        emit(AddTaskError(errorMessage: l.message));
      }, (r) {
        if (isClosed) return;
        emit(AddTaskSuccess());
      });
    } else {
      if (isClosed) return;
      emit(AddTaskError(errorMessage: 'Complete All Fields'));
    }
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
    result.fold((l) {
      if (pageNumber == 0) {
        if (isClosed) return;
        emit(GetTasksError(errorMessage: l.message));
      } else {
        if (isClosed) return;
        emit(GetTaskPaginationFailure(errorMessage: l.message));
      }
    }, (r) {
      if (isClosed) return;
      emit(GetTasksSuccess(tasks: r));
    });
  }

  Future<void> deleteTask({required Object id}) async {
    emit(DeleteTaskLoading());
    final result = await supervisorRepo.deleteTaskById(id: id.toString());
    result.fold((l) {
      emit(DeleteTaskError(errorMessage: l.message));
    }, (r) {
      emit(DeleteTaskSuccess());
    });
  }

  Future<void> assignTasks({required String taskId}) async {
    emit(AssignTaskLoading());
    if (selectedEmployeeId.isNotEmpty && assignDeadline.isNotEmpty) {
      final result = await supervisorRepo.assignTask(
        employeeId: selectedEmployeeId,
        taskId: taskId,
        deadLine: assignDeadline,
        priority: assignPriority,
        state: assignState,
      );
      result.fold((l) {
        emit(AssignTaskError(errorMessage: l.message));
      }, (r) {
        for (var token in selectedEmployeeTokens) {
          getIt<NotificationRepo>().sendSingleNotification(
              title: 'Task Assign',
              body: 'You have been assigned a new task',
              token: token);
        }
        emit(AssignTaskSuccess());
      });
    } else {
      emit(AssignTaskError(errorMessage: 'Select employee and deadline'));
    }
  }

  // change task Status
  Future<void> changeTaskStatus({required String taskId}) async {
    emit(ChangeTaskStatusLoading());
    final result = await supervisorRepo.changeTaskStatus(
        taskId: taskId, status: taskStatus);
    result.fold((l) {
      emit(ChangeTaskStatusError(errorMessage: l.message));
    }, (r) {
      getTasks();
      emit(ChangeTaskStatusSuccess());
    });
  }

  Future<void> deleteEmployeeFromTask(
      {required String taskId, required String employeeIds}) async {
    emit(RemoveEmployeeFromTaskLoading());

    final result = await supervisorRepo.removeSomeEmployeesFromTask(
        taskId: taskId, employeeIds: employeeIds);
    result.fold((l) {
      emit(RemoveEmployeeFromTaskError(errorMessage: l.message));
    }, (r) {
      getTasks();
      emit(RemoveEmployeeFromTaskSuccess());
    });
  }

  @override
  Future<void> close() async {
    titleController.dispose();
    descriptionController.dispose();
    super.close();
  }
}
