import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/core/common_methods/biometric_service.dart';
import 'package:hr_management_system_package/employee/data/models/user_attendace_model/employee_check_in_request_body.dart';
import 'package:hr_management_system_package/employee/data/models/user_attendace_model/get_plan_by_employee_id_model.dart';
import 'package:hr_management_system_package/employee/data/repo/attendance_repo/employee_attendance_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:hr_management_system_package/supervisor/data/models/plan_model/get_plan_by_id_model.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/enums/attendance_type_enum.dart';

part 'attendence_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final EmployeeAttendanceRepo employeeAttendanceRepo;
  AttendanceCubit(this.employeeAttendanceRepo) : super(AuthenticationInitial());
  File? selectedImage;

  LatLng initialCameraPosition =
      const LatLng(30.057065302568596, 31.34529175914667);
  String checkIn = '--/--';
  String checkOut = '--/--';
  String? customerId;
  Future<void> getUserBranch() async {
    emit(GetUserBranchLoading());
    final result = await employeeAttendanceRepo.getBranchesById();
    result.fold((l) {
      if (isClosed) return;
      emit(GetUserBranchError(l.message));
    }, (departmentModel) {
      if (isClosed) return;

      emit(GetUserBranchDone(departmentModel));
    });
  }

  Future<void> getCustomerArea() async {
    emit(GetCustomerAreaLoading());
    final result = await employeeAttendanceRepo.getCustomerPlanForEmployee();
    result.fold((l) {
      if (isClosed) return;

      emit(GetCustomerAreaError(l.message));
    }, (customerArea) {
      if (isClosed) return;

      emit(GetCustomerAreaDone(customerArea));
    });
  }

  Future<void> getPlanById({required int id}) async {
    emit(GetPlanByIdLoading());
    final result = await employeeAttendanceRepo.getPlanById(id: id);
    result.fold((l) {
      if (isClosed) return;

      emit(GetPlanByIdError(l.message));
    }, (planByEmployeeId) {
      if (isClosed) return;

      emit(GetPlanByIdIdDone(planByEmployeeId));
    });
  }

  void doCheckIn({required String area}) async {
    emit(AttendanceIneLoading());
    final result = await employeeAttendanceRepo.employeeCheckIn(
        EmployeeCheckInRequestBody(customerId, null,
            employeeIdd: ApiConstant.employeeId,
            area: area,
            location: 'location'));
    result.fold((l) {
      if (isClosed) return;

      emit(AttendanceInError(l.message));
    }, (userattendanceModel) {
      if (isClosed) return;

      checkIn = DateFormat('hh:mm').format(DateTime.now());
      emit(AttendanceIneDone(userattendanceModel));
    });
  }

  void doCheckOut() async {
    emit(AttendanceOutLoading());
    final result = await employeeAttendanceRepo.employeeCheckOut(
        employeeId: ApiConstant.employeeId);
    result.fold((l) {
      emit(AttendanceOutError(l.message));
    }, (userattendanceModel) {
      checkOut = DateFormat('hh:mm').format(DateTime.now());
      emit(AttendanceOutedDone(userattendanceModel));
    });
  }

  void attend({required String typeAttendance, required String area}) async {
    var hasBiometrics = await LocalAuthApi.fingerPrintAuthenticate();
    if (hasBiometrics) {
      emit(AuthenticationSuccess());
      if (typeAttendance == 'check_in') {
        doCheckIn(area: area);
      } else {
        doCheckOut();
      }
    } else {
      emit(AuthenticationFailed());
    }
  }

  void checkAssessableArea(
      LatLng pointLatNong, List<LatLng> area, Enum attendanceType) async {
    bool inRightArea = await employeeAttendanceRepo
        .checkAccessibleAreaForPloygon(pointLatNong, area);
    switch (attendanceType) {
      case AttendanceTypeEnum.checkIn:
        if (inRightArea == true) {
          emit(AccessAbleAreaState());
        } else {
          emit(AccessAbleAreaErrorState());
        }

      case AttendanceTypeEnum.checkOut:
        if (inRightArea == true) {
          emit(AccessAbleAreaState());
        } else {
          emit(AccessAbleAreaErrorState());
        }

      default:
    }
  }

  void checkAssessableAreaForCircle(LatLng pointLatNong, LatLng center,
      double radius, Enum attendanceType) async {
    log(pointLatNong.toString());
    bool isWithinCircle = employeeAttendanceRepo.checkAccessibleAreaForCircle(
            pointLatNong, center) <=
        radius;
    log(isWithinCircle.toString());
    switch (attendanceType) {
      case AttendanceTypeEnum.checkIn:
        if (isWithinCircle == true) {
          emit(AccessAbleAreaState());
        } else {
          emit(AccessAbleAreaErrorState());
        }
      case AttendanceTypeEnum.checkOut:
        if (isWithinCircle == true) {
          emit(AccessAbleAreaState());
        } else {
          emit(AccessAbleAreaErrorState());
        }

      default:
    }
  }
}
