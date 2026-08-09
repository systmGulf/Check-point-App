import 'package:dartz/dartz.dart';

import '../../../../admin_infrastructure/data/models/employee_model/all_employees_model.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/networking/api_constant.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../employee_infrastructure/data/models/employee_attendance_model/employee_check_in_request_body.dart';
import '../../../../employee_infrastructure/data/models/employee_attendance_model/user_tracking_summary_response_model.dart';
import '../../models/customers_model/get_customer_by_id_model.dart';
import '../../models/employee_summary_model/employee_attendance_summary_request_body.dart';
import '../../models/employee_summary_model/employee_summary_model.dart';
import '../../models/employees_attendance_model/get_employee_attendance.dart';
import '../../models/employees_attendance_model/supervisor_employee_check_out_request_body.dart';
import '../../../../core/networking/odoo_attendance_service.dart';
import 'supervisor_attendance_repo.dart';

class SupervisorAttendanceRepoImpl implements SupervisorAttendanceRepo {
  final ApiService apiService;
  final OdooAttendanceService odooAttendanceService;

  SupervisorAttendanceRepoImpl({
    required this.apiService,
    required this.odooAttendanceService,
  });
  @override
  // Get all employees attendance
  Future<Either<Failure, List<SupervisorGetAllEmployeesAttendanceModel>>>
      supervisorGetAllEmployeesAttendance() async {
    try {
      final result =
          await apiService.get(endPoint: ApiConstant.getEmployeeAttendance);
      if (result[ApiConstant.successApiKey] == true) {
        return Right((result['value'] as List)
            .map((e) => SupervisorGetAllEmployeesAttendanceModel.fromJson(e))
            .toList());
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Get employee attendance by department
  Future<Either<Failure, SupervisorAttendancePage>>
      getEmployeeAttendanceByDepartmentId(
          {required String attendanceDate}) async {
    try {
      final result = await apiService.get(
          endPoint:
              "${ApiConstant.getEmployeeAttendance}/departmentId/${ApiConstant.departmentId}?attendenceDate=$attendanceDate");
      if (result[ApiConstant.successApiKey] == true) {
        final response =
            SupervisorGetAllEmployeesAttendanceModel.fromJson(result);
        return Right(response.attendancePageOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Get employee by department
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
  // Get all employees
  Future<Either<Failure, List<EmployeesPage>>> getAllEmployees() async {
    try {
      final result = await apiService.get(endPoint: ApiConstant.employee);
      if (result[ApiConstant.successApiKey] == true) {
        return Right((result['value'] as List)
            .map((e) => GetAllEmployeesValue.fromJson(e))
            .toList());
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Attend some employee
  Future<Either<Failure, void>> supervisorAttendSomeEmployeeCheckIn(
      EmployeeCheckInRequestBody employeeCheckInRequestBody) async {
    try {
      if (employeeCheckInRequestBody.employeeImage != null) {
        final odooSuccess = await odooAttendanceService.syncCheckIn(
          employeeIdStr: employeeCheckInRequestBody.employeeIdd,
          area: employeeCheckInRequestBody.area,
        );
        if (!odooSuccess) {
          return const Left(Failure(500, 'Odoo synchronization failed. Attendance registration cancelled.'));
        }

        final result = await apiService.post(
            endPoint: ApiConstant.employeeCheckIn,
            body: employeeCheckInRequestBody.toJson());
        if (result[ApiConstant.successApiKey] == true) {
          return const Right(null);
        } else {
          return Left(ErrorHandler.responseFailure(result, fallbackCode: ResponseCode.badRequest));
        }
      } else {
        return Left(ErrorHandler.unexpectedFailure(message: 'Image is required', code: ResponseCode.badRequest));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Attend some employee
  Future<Either<Failure, void>> supervisorAttendSomeEmployeeCheckOut(
      String employeeId, String? employeeImage) async {
    try {
      if (employeeImage != null) {
        final odooSuccess = await odooAttendanceService.syncCheckOut(
          employeeIdStr: employeeId,
        );
        if (!odooSuccess) {
          return const Left(Failure(500, 'Odoo synchronization failed. Attendance registration cancelled.'));
        }

        final requestBody = SupervisorEmployeeCheckOutRequestBody(
          employeeId: employeeId,
          employeeImage: employeeImage,
        );
        final result = await apiService.post(
            endPoint: ApiConstant.employeeCheckOut,
            body: requestBody.toJson());
        if (result[ApiConstant.successApiKey] == true) {
          return const Right(null);
        } else {
          return Left(ErrorHandler.responseFailure(result));
        }
      } else {
        return Left(ErrorHandler.unexpectedFailure(message: 'Image is required', code: ResponseCode.badRequest));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Get employee summary
  Future<Either<Failure, AttendanceSummary>> getEmployeeSummary(
      {required String employeeId,
      required int month,
      required int year}) async {
    try {
      final requestBody = EmployeeAttendanceSummaryRequestBody(
        employeeId: employeeId,
        month: month,
        year: year,
      );
      final result = await apiService.get(
          body: requestBody.toJson(),
          endPoint: "${ApiConstant.getEmployeeAttendance}/attendanceSummary");
      if (result[ApiConstant.successApiKey] == true) {
        final response = EmployeeSummary.fromJson(result);
        return Right(response.summaryOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Get late comers
  Future<Either<Failure, SupervisorAttendancePage>>
      supervisorGetLateComers({required String day}) async {
    try {
      final result = await apiService.get(
          endPoint: "${ApiConstant.getEmployeeAttendance}/lateComers/$day");
      if (result[ApiConstant.successApiKey] == true) {
        final response =
            SupervisorGetAllEmployeesAttendanceModel.fromJson(result);
        return Right(response.attendancePageOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Get early leavers
  Future<Either<Failure, SupervisorAttendancePage>>
      supervisorGetEarlyLeavers({required String day}) async {
    try {
      final result = await apiService.get(
          endPoint: "${ApiConstant.getEmployeeAttendance}/earlyLeavers/$day");
      if (result[ApiConstant.successApiKey] == true) {
        final response =
            SupervisorGetAllEmployeesAttendanceModel.fromJson(result);
        return Right(response.attendancePageOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Get customer by id
  Future<Either<Failure, GetCustomerByIdModel>> getCustomerById(
      {required String customerId}) async {
    try {
      final result = await apiService.get(
          endPoint: "${ApiConstant.addCustomer}/$customerId");
      if (result['isSuccess'] == true) {
        return Right(GetCustomerByIdModel.fromJson(result));
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Get customer by id
  Future<Either<Failure, UserTrackingSummaryResponseBody>>
      getTrackingSummaryForEmployee(
          {required String data, required String employeeId}) async {
    try {
      final result = await apiService.get(
          endPoint:
              "${ApiConstant.getTrackingSummaryForEmployee}?employeeId=$employeeId&date=$data");
      if (result[ApiConstant.successApiKey] == true) {
        return Right(UserTrackingSummaryResponseBody.fromJson(result));
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
