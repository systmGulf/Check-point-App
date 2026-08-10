import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../supervisor_infrastructure/data/models/plan_model/get_plan_by_id_model.dart';
import '../../../../supervisor_infrastructure/data/models/plan_model/remove_assign_customer_plan_body.dart';

import '../../../../admin_infrastructure/data/models/branches_model/get_branches_models.dart';
import '../../../../admin_infrastructure/data/models/customers_model/get_customer_model.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../supervisor_infrastructure/data/models/plan_model/plan_feed_back_request_body.dart';
import '../../models/employee_attendance_model/employee_check_in_request_body.dart';
import '../../models/employee_attendance_model/get_plan_by_employee_id_model.dart';
import '../../models/employee_attendance_model/track_user_request_body.dart';
import '../employee_data.dart';

abstract class EmployeeAttendanceRepo {
  // Employee check in method
  Future<Either<Failure, UserAttendanceModel>> employeeCheckIn(
      EmployeeCheckInRequestBody employeeCheckInRequestBody);
  Future<Either<Failure, UserAttendanceModel>> employeeCheckInWithoutPlan(
      EmployeeCheckInRequestBody employeeCheckInRequestBody);
  // Employee Check out method
  Future<Either<Failure, UserAttendanceModel>> employeeCheckOut({
    required String employeeId,
  });
  Future<Either<Failure, UserAttendanceModel>> employeeCheckOutWithoutPlan({
    required String employeeId,
  });
  // Track UserLocation In background
  Future<Either<Failure, void>> trackEmployeeLocation(
      {required TrackUserRequestBody trackUserRequestBody});
  // get Attendance for employee
  Future<Either<Failure, UserAttendancePage>> getAllEmployeeAttendance(
      {int pageNumber = 0});
  // Get Customer plan To attend on it
  Future<Either<Failure, EmployeePlansModel>> getCustomerPlanForEmployee();
  Future<Either<Failure, CustomersPage>> getCustomersByType({
    required String type,
  });
  Future<Either<Failure, GetPlanByIdValue>> getPlanById({required int id});
  // Check user if he in the right location or no for Polygon
  Future<bool> checkAccessibleAreaForPolygon(
    LatLng pointLatLong,
    List<LatLng> area,
  );
  // Check user if he in the right location or no for Circle
  double checkAccessibleAreaForCircle(
      LatLng customerLocation, LatLng currentUserLocation);
  Future<Either<Failure, GetBranchesData>> getBranchesById();
  // feedback for attendance in customer or site
  Future<Either<Failure, void>> addPlanFeedBack(
      {required PlanFeedBackRequestBody planFeedBackRequestBody});

  Future<Either<Failure, void>> removeAssignCustomerPlan(
      {required RemoveAssignCustomerPlanBody removeAssignPlan});

  Future<Either<Failure, List<String>>> getFeedBackStatus();
}
