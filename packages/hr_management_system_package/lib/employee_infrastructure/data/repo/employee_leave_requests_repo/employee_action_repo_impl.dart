import 'package:dartz/dartz.dart';
import '../../../../hr_manamgement_system_package.dart';
import '../../models/employee_tasks_reponse_model/employee_tasks_response_model.dart';

class EmployeeActionRepoImpl implements EmployeeActionRepo {
  final ApiService apiService;

  EmployeeActionRepoImpl({
    required this.apiService,
  });

  @override
  // Create Leave Request
  Future<Either<Failure, UserAttendanceModel>> createLeaveRequest(
      LeaveRequestRequestBody leaveRequestRequestBody) async {
    try {
      final result = await apiService.post(
          endPoint: ApiConstant.leaveRequest,
          body: leaveRequestRequestBody.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        return Right(UserAttendanceModel.fromJson(result));
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Get All Leave Requests
  Future<Either<Failure, LeaveRequestsPage>>
      getAllLeaveRequestsForEmployee() async {
    try {
      final result = await apiService.get(
          endPoint:
              "${ApiConstant.getAllLeaveRequestsForEmployee}/${ApiConstant.employeeId}");
      if (result[ApiConstant.successApiKey] == true) {
        final response = EmployeeLeaveRequestsModel.fromJson(result);
        return Right(response.leaveRequestsPageOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Employee Change Password
  Future<Either<Failure, void>> employeeChangePassword(
      ChangePasswordRequestBody changePasswordRequestBody) async {
    try {
      final result = await apiService.put(
          endPoint: ApiConstant.employeeChangePassword,
          body: changePasswordRequestBody.toJson());
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
  // Delete Leave Request
  Future<Either<Failure, void>> deleteLeaveRequest({required int id}) async {
    try {
      final result =
          await apiService.delete(endPoint: "${ApiConstant.leaveRequest}/$id");
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
  // Get Leave Requests By Type for employee
  Future<Either<Failure, LeaveRequestsPage>>
      getLeaveRequestsByTypeForEmployee({required String type}) async {
    try {
      final result = await apiService.get(
          endPoint:
              "${ApiConstant.getAllLeaveRequestsForEmployee}/${ApiConstant.employeeId}/leaveType/$type");
      if (result[ApiConstant.successApiKey] == true) {
        final response = EmployeeLeaveRequestsModel.fromJson(result);
        return Right(response.leaveRequestsPageOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Get Employee By Department
  Future<Either<Failure, EmployeesPage>>
      getEmployeeByDepartmentId() async {
    try {
      final result = await apiService.get(
          endPoint:
              "${ApiConstant.employee}/departmentId/${ApiConstant.departmentId}");
      if (result[ApiConstant.successApiKey] == true) {
        final response = AllEmployeesModel.fromJson(result);
        return Right(response.employeesPageOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Get Employee Tasks
  Future<Either<Failure, EmployeeTasksResponseBody>> getEmployeeTasks() async {
    try {
      final result = await apiService.get(
          endPoint:
              "${ApiConstant.task}/specificEmployee?employeeId=${ApiConstant.employeeId}");
      if (result[ApiConstant.successApiKey] == true) {
        return Right(EmployeeTasksResponseBody.fromJson(result));
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Change Employee Task Status
  Future<Either<Failure, void>> changeEmployeeTaskStatus(
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
  // Delete Task
  Future<Either<Failure, void>> deleteTask(
      {required int taskId, required String employeeId}) async {
    final requestBody = RemoveAssignTaskRequestBody(
      employeeId: employeeId,
      taskId: taskId,
    );
    try {
      final result = await apiService.post(
          endPoint: ApiConstant.removeTaskFromEmployee,
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
