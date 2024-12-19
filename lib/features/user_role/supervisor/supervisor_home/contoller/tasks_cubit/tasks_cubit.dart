import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/supervisor/data/models/task_model/add_task_request_body.dart';
import 'package:hr_management_system_package/supervisor/data/models/task_model/get_task_response.dart';
import 'package:hr_management_system_package/supervisor/supervisor_data.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final SupervisorRepo supervisorRepo;
  TasksCubit(this.supervisorRepo) : super(TasksInitial());
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String dueDate = '';
  String priorityStatus = 'high';
  List<String> employeeIds = [];
  List<GetTasData> tasks = [];
  Future<void> addTask() async {
    emit(AddTaskLoading());
    if (dueDate != '') {
      final result = await supervisorRepo.addTask(
        addTaskRequestBody: AddTaskRequestBody(
          title: titleController.text,
          description: descriptionController.text,
          dueDate: dueDate,
          priorityStatus: priorityStatus,
          status: 'Pending',
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
    final result = await supervisorRepo.getAllTasksById(
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

  Future<void> deleteTask({required int id}) async {
    emit(DeleteTaskLoading());
    final result = await supervisorRepo.deleteTaskById(id: id);
    result.fold((l) {
      emit(DeleteTaskError(errorMessage: l.message));
    }, (r) {
      emit(DeleteTaskSuccess());
    });
  }

  Future<void> assignTasks({required int taskId}) async {
    emit(AssignTaskLoading());
    if (employeeIds.isNotEmpty) {
      final result = await supervisorRepo.assignTask(
        employeeIds: employeeIds,
        taskId: taskId,
      );
      result.fold((l) {
        emit(AssignTaskError(errorMessage: l.message));
      }, (r) {
        emit(AssignTaskSuccess());
      });
    } else {
      emit(AssignTaskError(errorMessage: 'Select Employee'));
    }
  }
}
