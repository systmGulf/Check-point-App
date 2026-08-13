import 'package:dartz/dartz.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_tasks_repo/supervisor_tasks_repo.dart';

import '../../models/task_model/add_task_request_body.dart';
import '../../models/task_model/get_task_response.dart';

class SupervisorTasksRepoImpl implements SupervisorTasksRepo {
  final ApiService apiService;

  SupervisorTasksRepoImpl({
    required this.apiService,
  });

  @override
  // add Task
  Future<Either<Failure, int?>> addTask(
      {required AddTaskRequestBody addTaskRequestBody}) async {
    try {
      final result = await apiService.post(
          endPoint: ApiConstant.task, body: addTaskRequestBody.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        dynamic taskValue = result['value'];
        int? createdTaskId;
        if (taskValue != null) {
          if (taskValue is Map && taskValue['id'] != null) {
            createdTaskId = int.tryParse(taskValue['id'].toString());
          } else if (taskValue is int) {
            createdTaskId = taskValue;
          } else if (taskValue is String) {
            createdTaskId = int.tryParse(taskValue);
          }
        }
        return Right(createdTaskId);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Get all Tasks by Department
  Future<Either<Failure, List<GetTasData>>> getAllTasksByDepartmentId(
      {required int pageNumber}) async {
    try {
      final endPoint = ApiConstant.departmentId.isEmpty
          ? ApiConstant.task
          : "${ApiConstant.task}/department/${ApiConstant.departmentId}";
      final result = await apiService.get(endPoint: endPoint);
      if (result[ApiConstant.successApiKey] == true) {
        return Right(
          List<GetTasData>.from((result['value']['data'] as List)
              .map((e) => GetTasData.fromJson(e))),
        );
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Delete Task By Id
  Future<Either<Failure, void>> deleteTaskById({required int id}) async {
    try {
      final result =
          await apiService.delete(endPoint: "${ApiConstant.task}?id=$id");
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Assign Task
  Future<Either<Failure, void>> assignTask(
      {required int taskId, required List<String> employeeIds}) async {
    try {
      final requestBody = AssignTaskRequestBody(
        employeeIds: employeeIds,
        taskId: taskId,
      );
      final result = await apiService.post(
          endPoint: "${ApiConstant.task}/assignTask",
          body: requestBody.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Change Task Status
  Future<Either<Failure, void>> changeTaskStatus(
      {required int taskId, required String status}) async {
    try {
      final requestBody = UpdateTaskStatusRequestBody(
        id: taskId,
        status: status,
      );
      final result = await apiService.put(
          endPoint: "${ApiConstant.task}/updateStatus",
          body: requestBody.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> removeSomeEmployeesFromTask(
      {required int taskId, required String employeeIds}) async {
    try {
      final requestBody = RemoveAssignTaskRequestBody(
        employeeId: employeeIds,
        taskId: taskId,
      );
      final result = await apiService.post(
          endPoint: "${ApiConstant.employee}/removeAssignTask",
          body: requestBody.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
