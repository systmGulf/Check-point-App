import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/core/common_methods/biometric_service.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/employee_check_in_request_body.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/get_plan_by_employee_id_model.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_attendance_repo/employee_attendance_repo.dart';

import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/get_plan_by_id_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/plan_feed_back_request_body.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../core/common/image_picker.dart';
import '../../../../../../core/enums/attendance_type_enum.dart';

part 'attendence_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final EmployeeAttendanceRepo employeeAttendanceRepo;
  AttendanceCubit(this.employeeAttendanceRepo) : super(AuthenticationInitial());
    String selectedImage = '';

  LatLng initialCameraPosition =
      const LatLng(30.057065302568596, 31.34529175914667);
  String checkIn = '--/--';
  String checkOut = '--/--';
  String? customerId;
  TextEditingController planFeedbackController = TextEditingController();

  Future<void> getUserBranch() async {
    emit(GetUserBranchLoading());
    final result = await employeeAttendanceRepo.getBranchesById();
    result.fold((l) {
      if (isClosed) return;
      emit(GetUserBranchError(l.message));
    }, (departmentModel) async {
      if (isClosed) return;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Map<String, double?>> areaMap = departmentModel.coordinates!
          .map((e) => {'latitude': e.latitude, 'longitude': e.longitude})
          .toList();
      String areaJson = jsonEncode(areaMap);
      await prefs.setString('area', areaJson);
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
  // pick image
    Future<void> doPickImage() async {
     emit(PickImageLoading());
      String ? result = await pickImage();
        if (result != null) {
          selectedImage = result;
          emit(PickImageSuccess());
        } else {
          emit(PickImageFailed()); 
        }
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

  // customer or site plan feedback
  Future<void> addPlanFeedback(
      {required int CustomerId, String status = 'Done'}) async {
    emit(AddPlanFeedbackLoading());
    final result = await employeeAttendanceRepo.addPlanFeedBack(
      planFeedBackRequestBody: PlanFeedBackRequestBody(
          imageUrl: selectedImage,
          notes: planFeedbackController.text,
          customerPlanId: CustomerId,
          status: status),
    );
    result.fold((l) {
      if (isClosed) return;

      emit(AddPlanFeedbackError(l.message));
    }, (r) {
      if (isClosed) return;

      emit(AddPlanFeedbackDone());
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
    }, (userattendanceModel) async {
      // get location from shared preferences

      checkIn = DateFormat('hh:mm').format(DateTime.now());
      emit(AttendanceIneDone(userattendanceModel));
    });
  }

  void doCheckOut() async {
    emit(AttendanceOutLoading());
    final result = await employeeAttendanceRepo.employeeCheckOut(
        employeeId: ApiConstant.employeeId);
    result.fold((l) {
      if (isClosed) return;
      emit(AttendanceOutError(l.message));
    }, (userattendanceModel) async {
      checkOut = DateFormat('hh:mm').format(DateTime.now());
      emit(AttendanceOutedDone(userattendanceModel));
      FlutterBackgroundService().invoke('stopService');
    });
  }

  void attend({required String typeAttendance, required String area}) async {
    var hasBiometrics = await LocalAuthApi.fingerPrintAuthenticate();
    if (hasBiometrics) {
      if (isClosed) return;
      emit(AuthenticationSuccess());
      if (typeAttendance == 'check_in') {
        doCheckIn(area: area);
      } else {
        doCheckOut();
      }
    } else {
      if (isClosed) return;
      if (typeAttendance == 'check_in') {
        doCheckIn(area: area);
      } else {
        doCheckOut();
      }
    }
  }

  void checkAssessableArea(
      LatLng pointLatNong, List<LatLng> area, Enum attendanceType) async {
    bool inRightArea = await employeeAttendanceRepo
        .checkAccessibleAreaForPolygon(pointLatNong, area);

    switch (attendanceType) {
      case AttendanceTypeEnum.checkIn:
        if (inRightArea == true) {
          if (isClosed) return;
          emit(AccessAbleAreaState());
        } else {
          if (isClosed) return;
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
    
    bool isWithinCircle = employeeAttendanceRepo.checkAccessibleAreaForCircle(
            pointLatNong, center) <=
        radius;
   
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
