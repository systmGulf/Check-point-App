import 'package:dartz/dartz.dart';

import '../../../../hr_manamgement_system_package.dart';
import '../../models/employee_tasks_reponse_model/employee_tasks_response_model.dart';

abstract class EmployeeActionRepo {
  // Create Leave Request
  Future<Either<Failure, UserAttendanceModel>> createLeaveRequest(
      LeaveRequestRequestBody leaveRequestRequestBody);
  // Get all Leave Requests
  Future<Either<Failure, LeaveRequestsPage>>
      getAllLeaveRequestsForEmployee();
  // Get Leave Requests By Type
  Future<Either<Failure, LeaveRequestsPage>>
      getLeaveRequestsByTypeForEmployee({required String type});
  // Employee Change Password
  Future<Either<Failure, void>> employeeChangePassword(
      ChangePasswordRequestBody changePasswordRequestBody);
  // Delete Leave Request
  Future<Either<Failure, void>> deleteLeaveRequest({required int id});
  // Get Employee By Department Id
  Future<Either<Failure, EmployeesPage>> getEmployeeByDepartmentId();
  // Get Employee Task

  /// THE MODEL HERE IS WRONG NOW WE WANT TO CREATE A NEW MODEL FOR EMPLOYEE TASKS
  Future<Either<Failure, EmployeeTasksResponseBody>> getEmployeeTasks();
  // Change Employee Task Status
  Future<Either<Failure, void>> changeEmployeeTaskStatus(
      {required int taskId, required String status});
  // delete task
  Future<Either<Failure, void>> deleteTask(
      {required int taskId, required String employeeId});
}
