import 'package:dartz/dartz.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/task_model/get_task_response.dart';

import '../../../../core/errors/error_handler.dart';
import '../../models/task_model/add_task_request_body.dart';

abstract class SupervisorTasksRepo {
  // add Tasks
  Future<Either<Failure, int?>> addTask(
      {required AddTaskRequestBody addTaskRequestBody});
  // Get all Tasks by department Id
  Future<Either<Failure, List<GetTasData>>> getAllTasksByDepartmentId(
      {required int pageNumber});
  // Delete Task by id
  Future<Either<Failure, void>> deleteTaskById({required int id});
  Future<Either<Failure, void>> removeSomeEmployeesFromTask(
    {required int taskId, required String employeeIds}
  );

  // Assign Task to employees
  Future<Either<Failure, void>> assignTask(
      {required int taskId, required List<String> employeeIds});
  // Change Task Status from Pending to Completed Or inProgress
  Future<Either<Failure, void>> changeTaskStatus(
      {required int taskId, required String status});
}
