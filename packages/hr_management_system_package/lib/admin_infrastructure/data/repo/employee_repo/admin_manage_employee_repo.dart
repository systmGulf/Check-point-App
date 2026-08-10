import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../models/employee_model/add_account_request_model.dart';
import '../../models/employee_model/add_employee_request_body.dart';
import '../../models/employee_model/all_employees_model.dart';
import '../../models/employee_model/edit_employee_request_body.dart';
import '../../models/department_model/get_employees_in_department.dart';

abstract class AdminManageEmployeeRepo {
  // get all employees
  Future<Either<Failure, EmployeesPage>> getAllEmployees({
    required int pageNumber,
    required int itemCount,
  });
  // search employees
  Future<Either<Failure, EmployeesPage>> searchEmployees({
    required String searchKey,
  });
  // add employee
  Future<Either<Failure, void>> addEmployee(AddEmployeeRequestBody request);
  //  Delete employee Account
  Future<Either<Failure, void>> deleteEmployeeAccount({required String userId});
// Edit employee
  Future<Either<Failure, void>> editEmployee(
      EditEmployeeRequestBody requestBody,
      {required String id});
  // get employees in department
  Future<Either<Failure, EmployeesInDepartmentPage>>
      getEmployeesInDepartment(
          {required int id, required int pageKey, required int pageSize});

  /// THIS IS PERMISSIONS FOR SUPERVISOR THAT HE CAN ATTEND SOME ONE ELSE OR SET PLAN PERMISSION
  // set attend anther user permission
  Future<Either<Failure, void>> attendAntherUserPermission(
      {required String supervisorId, required bool permission});
  // set plan permission
  Future<Either<Failure, void>> setPlanPermission(
      {required bool permission, required String supervisorId});
  // when the user request to add account for his this account go to admin
  Future<Either<Failure, AddAccountRequestsPage>>
      getAddAccountRequestsForAdmin(
      {required int pageNumber, required int itemCount});
  // delete add account request
  Future<Either<Failure, void>> deleteAddAccountRequestsForAdmin(
      {required int id});
}
