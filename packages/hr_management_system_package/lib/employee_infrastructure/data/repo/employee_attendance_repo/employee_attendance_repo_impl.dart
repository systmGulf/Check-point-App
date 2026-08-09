import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/track_user_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/remove_assign_customer_plan_body.dart';
import '../../../../supervisor_infrastructure/data/models/plan_model/get_plan_by_id_model.dart';

import '../../../../admin_infrastructure/data/models/branches_model/get_branches_models.dart';
import '../../../../admin_infrastructure/data/models/customers_model/get_customer_model.dart';
import '../../../../core/common_methods/check_accessiable_area_service.dart';
import '../../../../core/core.dart';
import '../../../../supervisor_infrastructure/data/models/plan_model/plan_feed_back_request_body.dart';
import '../../models/employee_attendance_model/employee_check_in_request_body.dart';
import '../../models/employee_attendance_model/employee_check_out_request_body.dart';
import '../../models/employee_attendance_model/get_plan_by_employee_id_model.dart';
import '../../models/employee_attendance_model/user_attendace_model.dart';
import 'employee_attendance_repo.dart';
import '../../../../core/networking/odoo_attendance_service.dart';

class EmployeeAttendanceRepoImpl implements EmployeeAttendanceRepo {
  final ApiService apiService;
  final CheckAccessibleAreaService checkAccessibleAreaService;
  final OdooAttendanceService odooAttendanceService;

  EmployeeAttendanceRepoImpl(
    this.checkAccessibleAreaService, {
    required this.apiService,
    required this.odooAttendanceService,
  });

  @override
  // Get Branch By Id for the User
  Future<Either<Failure, GetBranchesData>> getBranchesById() async {
    try {
      final result = await apiService.get(
          endPoint: "${ApiConstant.branches}/${ApiConstant.branchId}");
      if (result[ApiConstant.successApiKey] == true) {
        return Right(GetBranchesData.fromJson(result['value']));
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // Get Customer Plan For Employee
  Future<Either<Failure, EmployeePlansModel>>
      getCustomerPlanForEmployee() async {
    try {
      final result = await apiService.get(
          endPoint: "${ApiConstant.plan}/employee/${ApiConstant.employeeId}");
      if (result[ApiConstant.successApiKey] == true) {
        return Right(EmployeePlansModel.fromJson(result));
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, CustomersPage>> getCustomersByType(
      {required String type}) async {
    try {
      final result = await apiService.get(
          endPoint: "${ApiConstant.addCustomer}/customerType/$type");
      if (result[ApiConstant.successApiKey] == true) {
        final response = CustomerModel.fromJson(result);
        return Right(response.customersPageOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  // check if the user in the right zoon for an Customer
  @override
  double checkAccessibleAreaForCircle(
      LatLng customerLocation, LatLng currentUserLocation) {
    return checkAccessibleAreaService.checkAccessibleAreaForCircle(
        customerLocation, currentUserLocation);
  }

  @override
  //  Employee Check in
  Future<Either<Failure, UserAttendanceModel>> employeeCheckIn(
      EmployeeCheckInRequestBody employeeCheckInRequestBody) async {
    try {
      final result = await apiService.post(
          endPoint: ApiConstant.employeeCheckIn,
          body: employeeCheckInRequestBody.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        final attendance = UserAttendanceModel.fromJson(result);
        odooAttendanceService.syncCheckIn(
          employeeIdStr: employeeCheckInRequestBody.employeeIdd,
          area: employeeCheckInRequestBody.area,
        );
        return Right(attendance);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, UserAttendanceModel>> employeeCheckInWithoutPlan(
      EmployeeCheckInRequestBody employeeCheckInRequestBody) async {
    try {
      final result = await apiService.post(
          endPoint: ApiConstant.employeeCheckInWithoutPlan,
          body: employeeCheckInRequestBody.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        final attendance = UserAttendanceModel.fromJson(result);
        odooAttendanceService.syncCheckIn(
          employeeIdStr: employeeCheckInRequestBody.employeeIdd,
          area: employeeCheckInRequestBody.area,
        );
        return Right(attendance);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  // employee check out
  @override
  Future<Either<Failure, UserAttendanceModel>> employeeCheckOut(
      {required String employeeId}) async {
    try {
      final requestBody = EmployeeCheckOutRequestBody(
        employeeId: employeeId,
        employeeImage: null,
      );
      final result = await apiService.post(
          endPoint: ApiConstant.employeeCheckOut, body: requestBody.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        final attendance = UserAttendanceModel.fromJson(result);
        odooAttendanceService.syncCheckOut(
          employeeIdStr: employeeId,
        );
        return Right(attendance);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, UserAttendanceModel>> employeeCheckOutWithoutPlan(
      {required String employeeId}) async {
    try {
      final requestBody = EmployeeCheckOutRequestBody(
        employeeId: employeeId,
        employeeImage: null,
      );
      final result = await apiService.post(
          endPoint: ApiConstant.employeeCheckOutWithoutPlan,
          body: requestBody.toJson());
      if (result[ApiConstant.successApiKey] == true) {
        final attendance = UserAttendanceModel.fromJson(result);
        odooAttendanceService.syncCheckOut(
          employeeIdStr: employeeId,
        );
        return Right(attendance);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // get all employee attendance
  Future<Either<Failure, UserAttendancePage>> getAllEmployeeAttendance(
      {int pageNumber = 0}) async {
    try {
      final result = await apiService.get(
        endPoint:
            "${ApiConstant.getEmployeeAttendanceHistory}/${ApiConstant.employeeId}?itemCount=10&index=${pageNumber * 10}",
      );
      if (result[ApiConstant.successApiKey] == true) {
        final response = UserAttendanceModel.fromJson(result);
        return Right(response.attendancePageOrEmpty);
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // get plan by id
  Future<Either<Failure, GetPlanByIdValue>> getPlanById(
      {required int id}) async {
    try {
      final result = await apiService.get(endPoint: "${ApiConstant.plan}/$id");
      if (result[ApiConstant.successApiKey] == true) {
        return Right(GetPlanByIdValue.fromJson(result['value']));
      } else {
        return Left(ErrorHandler.responseFailure(result));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  // check if the user in the right zoon for site
  Future<bool> checkAccessibleAreaForPolygon(
      LatLng pointLatNong, List<LatLng> area) async {
    return await checkAccessibleAreaService.checkAccessibleAreaForPolygon(
        pointLatNong, area);
  }

  @override
  // add feed back for an customer or site plan
  Future<Either<Failure, void>> addPlanFeedBack(
      {required PlanFeedBackRequestBody planFeedBackRequestBody}) async {
    try {
      final result = await apiService.post(
          endPoint: ApiConstant.planFeedback,
          body: planFeedBackRequestBody.toJson());
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
  // track employee location in the background
  Future<Either<Failure, void>> trackEmployeeLocation(
      {required TrackUserRequestBody trackUserRequestBody}) async {
    try {
      final result = await apiService.post(
          endPoint: ApiConstant.trackEmployeeLocation,
          body: trackUserRequestBody.toJson());
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
  Future<Either<Failure, void>> removeAssignCustomerPlan(
      {required RemoveAssignCustomerPlanBody removeAssignPlan}) async {
    try {
      final response = await apiService.post(
          endPoint: ApiConstant.removeAsignCustomerPlan,
          body: removeAssignPlan.toJson());
      if (response[ApiConstant.successApiKey] == true) {
        return const Right(null);
      } else {
        return Left(ErrorHandler.responseFailure(response));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<String>>> getFeedBackStatus() async {
    try {
      final response =
          await apiService.get(endPoint: ApiConstant.feedBackStatus);
      if (response[ApiConstant.successApiKey] == true) {
        final List<String> statusList = List<String>.from(response['value']);

        return Right(statusList);
      } else {
        return Left(ErrorHandler.responseFailure(response));
      }
    } on Object catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
