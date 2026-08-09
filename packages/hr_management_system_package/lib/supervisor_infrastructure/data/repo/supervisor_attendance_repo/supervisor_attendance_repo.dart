import 'package:dartz/dartz.dart';

import '../../../../admin_infrastructure/data/models/employee_model/all_employees_model.dart';
import '../../../../core/core.dart';
import '../../../../employee_infrastructure/data/models/employee_attendance_model/employee_check_in_request_body.dart';
import '../../../../employee_infrastructure/data/models/employee_attendance_model/user_tracking_summary_response_model.dart';
import '../../models/customers_model/get_customer_by_id_model.dart';
import '../../models/employee_summary_model/employee_summary_model.dart';
import '../../models/employees_attendance_model/get_employee_attendance.dart';

abstract class SupervisorAttendanceRepo {
  // Supervisor Get All Employees Attendance
  Future<Either<Failure, List<SupervisorGetAllEmployeesAttendanceModel>>>
      supervisorGetAllEmployeesAttendance();
  // Get Employee Attendance By Department Id
  Future<Either<Failure, SupervisorAttendancePage>>
      getEmployeeAttendanceByDepartmentId({required String attendanceDate});
  // Get All Employees in Department
  Future<Either<Failure, List<EmployeesPage>>> getAllEmployees();
  // Get Employee By Department Id
  Future<Either<Failure, EmployeesPage>> getEmployeeByDepartmentId();
  // Supervisor Attend Some Employee Check In
  Future<Either<Failure, void>> supervisorAttendSomeEmployeeCheckIn(
      EmployeeCheckInRequestBody employeeCheckInRequestBody);
  // Supervisor Attend Some Employee Check Out
  Future<Either<Failure, void>> supervisorAttendSomeEmployeeCheckOut(
      String employeeId, String? employeeImage);
  // Get Employee Summary
  Future<Either<Failure, AttendanceSummary>> getEmployeeSummary(
      {required String employeeId, required int month, required int year});
  // Supervisor Get Late Comers
  Future<Either<Failure, SupervisorAttendancePage>>
      supervisorGetLateComers({required String day});
  // Supervisor Get Early Leavers
  Future<Either<Failure, SupervisorAttendancePage>>
      supervisorGetEarlyLeavers({required String day});
  // Get Customer By Id
  Future<Either<Failure, GetCustomerByIdModel>> getCustomerById(
      {required String customerId});
  // Get Tracking Summary For Employee
  Future<Either<Failure, UserTrackingSummaryResponseBody>>
      getTrackingSummaryForEmployee(
          {required String data, required String employeeId});
}
