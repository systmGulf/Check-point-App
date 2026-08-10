import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';

import '../../../../core/networking/api_constant.dart';
import '../../../../core/networking/api_service.dart';
import '../../models/employee_model/add_account_request_model.dart';
import '../../models/employee_model/add_employee_request_body.dart';
import '../../models/employee_model/all_employees_model.dart';
import '../../models/employee_model/edit_employee_request_body.dart';
import '../../models/department_model/get_employees_in_department.dart';
import 'admin_manage_employee_repo.dart';

class AdminManageEmployeeRepoImpl implements AdminManageEmployeeRepo {
  final ApiService apiService;

  AdminManageEmployeeRepoImpl({
    required this.apiService,
  });

  @override
  // add Employee
  Future<Either<Failure, void>> addEmployee(
      AddEmployeeRequestBody request) async {
    try {
      final result = await apiService.post(
          endPoint: ApiConstant.employee, body: request.toJson());
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
  // delete Employee
  Future<Either<Failure, void>> deleteEmployeeAccount(
      {required String userId}) async {
    try {
      final result = await apiService.delete(
          endPoint: "${ApiConstant.deleteEmployee}/$userId");
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
  // edit Employee
  Future<Either<Failure, void>> editEmployee(
      EditEmployeeRequestBody requestBody,
      {required String id}) async {
    try {
      final result = await apiService.put(
          endPoint: "${ApiConstant.employee}/$id", body: requestBody.toJson());
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
  // get All Employee
  Future<Either<Failure, EmployeesPage>> getAllEmployees(
      {required int pageNumber, required int itemCount}) async {
    try {
      final result = await apiService.get(
          endPoint:
              "${ApiConstant.employee}?itemCount=$itemCount&index=${pageNumber * 10}");
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
  // get Employee In Department
  Future<Either<Failure, EmployeesInDepartmentPage>>
      getEmployeesInDepartment(
          {required int id,
          required int pageKey,
          required int pageSize}) async {
    try {
      final endPoint = "${ApiConstant.employee}/departmentId/$id";

      final result = await apiService.get(endPoint: endPoint);
      if (result[ApiConstant.successApiKey] == true) {
        final response = GetEmployeesInDepartmentModel.fromJson(result);
        return Right(response.employeesPageOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // set attend anther user permission
  Future<Either<Failure, void>> attendAntherUserPermission(
      {required String supervisorId, required bool permission}) async {
    try {
      final result = await apiService.post(
          endPoint:
              "${ApiConstant.employee}/employeeId/$supervisorId/attendancePermission/$permission",
          body: {});
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
  // set plan anther user permission
  Future<Either<Failure, void>> setPlanPermission(
      {required bool permission, required String supervisorId}) async {
    try {
      final result = await apiService.post(
          endPoint:
              "${ApiConstant.employee}/employeeId/$supervisorId/planPermission/$permission",
          body: {});
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
  // get add account request
  Future<Either<Failure, AddAccountRequestsPage>>
      getAddAccountRequestsForAdmin(
      {required int pageNumber, required int itemCount}) async {
    try {
      final result = await apiService.get(
          endPoint:
              "${ApiConstant.accountRequest}?itemCount=$itemCount&index=${pageNumber * 10}");

      if (result[ApiConstant.successApiKey] == true) {
        final response = AddAccountRequestModel.fromJson(result);
        return Right(response.accountRequestsPageOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // delete add account request
  Future<Either<Failure, void>> deleteAddAccountRequestsForAdmin(
      {required int id}) async {
    try {
      final result = await apiService.delete(
          endPoint: "${ApiConstant.accountRequest}?id=$id");
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
  Future<Either<Failure, EmployeesPage>> searchEmployees({
    required String searchKey,
  }) async {
    try {
      final result = await apiService.get(
          endPoint: "${ApiConstant.employee}/search/$searchKey");
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
}
