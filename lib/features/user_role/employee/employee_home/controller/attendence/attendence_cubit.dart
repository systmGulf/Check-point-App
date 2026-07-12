import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/core/common_methods/track_user_in_background.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/employee_check_in_request_body.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/get_plan_by_employee_id_model.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_attendance_repo/employee_attendance_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart'
    hide Value;
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/get_plan_by_id_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/plan_feed_back_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/remove_assign_customer_plan_body.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../core/common/image_picker_base_64.dart';
import '../../../../../../core/enums/attendance_type_enum.dart';
import '../../../../../../core/enums/customer_type.dart';

part 'attendence_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  static const String trackingEnabledKey = 'employee_tracking_enabled';

  final EmployeeAttendanceRepo employeeAttendanceRepo;
  AttendanceCubit({required this.employeeAttendanceRepo})
      : super(AuthenticationInitial());
  String selectedImage = '';

  LatLng initialCameraPosition =
      const LatLng(30.057065302568596, 31.34529175914667);
  String checkIn = '--/--';
  String checkOut = '--/--';
  String planStatus = 'FollowUp';
  String? customerId;
  CustomerType? selectedAttendanceTargetType;
  CustomerData? selectedAttendanceTarget;
  List<CustomerData> attendanceTargets = [];
  LatLng? currentUserLocation;
  bool isTrackingEnabled = false;
  TextEditingController planFeedbackController = TextEditingController();

  Future<void> loadTrackingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isTrackingEnabled = prefs.getBool(trackingEnabledKey) ?? false;
    if (isClosed) return;
    emit(TrackingStatusChanged(isTrackingEnabled));
  }

  Future<void> goOnline() async {
    if (isTrackingEnabled) {
      if (isClosed) return;
      emit(TrackingStatusChanged(true));
      return;
    }

    emit(TrackingLoading());
    final hasLocationAccess = await handleLocationPermissionAndGPS();
    if (!hasLocationAccess) {
      if (isClosed) return;
      emit(TrackingError('Enable location access to go online'));
      return;
    }

    final service = FlutterBackgroundService();
    final started = await service.startService();
    if (!started) {
      if (isClosed) return;
      emit(TrackingError('Unable to start background tracking'));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    isTrackingEnabled = true;
    await prefs.setBool(trackingEnabledKey, true);
    if (isClosed) return;
    emit(TrackingStarted());
    emit(TrackingStatusChanged(true));
  }

  Future<void> stopTracking() async {
    final service = FlutterBackgroundService();
    service.invoke('stop');
    final prefs = await SharedPreferences.getInstance();
    isTrackingEnabled = false;
    await prefs.setBool(trackingEnabledKey, false);
    if (isClosed) return;
    emit(TrackingStopped());
    emit(TrackingStatusChanged(false));
  }

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

  Future<void> getAttendanceTargets(
      {required CustomerType customerType}) async {
    emit(GetAttendanceTargetsLoading());
    selectedAttendanceTargetType = customerType;
    selectedAttendanceTarget = null;
    currentUserLocation = null;
    customerId = null;
    final result = await employeeAttendanceRepo.getCustomersByType(
        type: customerType.name);

    result.fold((failure) {
      if (isClosed) return;
      attendanceTargets = [];
      emit(GetAttendanceTargetsError(failure.message));
    }, (customersPage) {
      if (isClosed) return;
      attendanceTargets = customersPage.data ?? [];
      if (attendanceTargets.isNotEmpty) {
        selectedAttendanceTarget = attendanceTargets.first;
        customerId = selectedAttendanceTarget!.id;
      }
      emit(GetAttendanceTargetsDone(
        targets: attendanceTargets,
        customerType: customerType,
      ));
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
  Future<void> doPickImage({required ImagePickSource source}) async {
    emit(PickImageLoading());
    String? result = await ImagePickerHelper.pickImageBase64(
      source: source,
    );
    if (result != null) {
      selectedImage = result;
      emit(PickImageSuccess());
    } else {
      emit(PickImageFailed());
    }
  }

  // Future<void> getPlanById({required int id}) async {
  //   emit(GetPlanByIdLoading());
  //   final result = await employeeAttendanceRepo.getPlanById(id: id);
  //   result.fold((l) {
  //     if (isClosed) return;

  //     emit(GetPlanByIdError(l.message));
  //   }, (planByEmployeeId) {
  //     if (isClosed) return;

  //     emit(GetPlanByIdIdDone(planByEmployeeId));
  //   });
  // }

  // customer or site plan feedback
  Future<void> addPlanFeedback({
    required int CustomerId,
  }) async {
    emit(AddPlanFeedbackLoading());
    if (customerId == null)
      return emit(AddPlanFeedbackError('Tap on customer or site please '));
    final result = await employeeAttendanceRepo.addPlanFeedBack(
      planFeedBackRequestBody: PlanFeedBackRequestBody(
          status: planStatus,
          imageUrl: selectedImage,
          notes: planFeedbackController.text,
          customerPlanId: CustomerId),
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
    final requestBody = EmployeeCheckInRequestBody(
      customerId,
      null,
      employeeIdd: ApiConstant.employeeId,
      area: area,
      location: _currentLocationLabel(area: area),
      coordinates: _currentCoordinates,
    );
    final result = area == 'Office'
        ? await employeeAttendanceRepo.employeeCheckIn(requestBody)
        : await employeeAttendanceRepo.employeeCheckInWithoutPlan(requestBody);
    result.fold((l) {
      if (isClosed) return;

      emit(AttendanceInError(l.message));
    }, (userattendanceModel) async {
      // get location from shared preferences

      checkIn = DateFormat('hh:mm').format(DateTime.now());
      emit(AttendanceIneDone(userattendanceModel));
    });
  }

  void doCheckOut({required String area}) async {
    emit(AttendanceOutLoading());
    final result = area == 'Office'
        ? await employeeAttendanceRepo.employeeCheckOut(
            employeeId: ApiConstant.employeeId)
        : await employeeAttendanceRepo.employeeCheckOutWithoutPlan(
            employeeId: ApiConstant.employeeId);
    result.fold((l) {
      if (isClosed) return;
      emit(AttendanceOutError(l.message));
    }, (userattendanceModel) async {
      checkOut = DateFormat('hh:mm').format(DateTime.now());
      emit(AttendanceOutedDone(userattendanceModel));
    });
  }

  void attend({required String typeAttendance, required String area}) async {
    if (area != 'Office' && selectedAttendanceTarget == null) {
      final areaLabel = area.toLowerCase();
      if (typeAttendance == 'check_in') {
        emit(AttendanceInError('Please select a $areaLabel first'));
      } else {
        emit(AttendanceOutError('Please select a $areaLabel first'));
      }
      return;
    }
    if (typeAttendance == 'check_in') {
      doCheckIn(area: area);
    } else {
      doCheckOut(area: area);
    }
  }

  void checkAssessableArea(
      LatLng pointLatNong, List<LatLng> area, Enum attendanceType) async {
    bool inRightArea = await employeeAttendanceRepo
        .checkAccessibleAreaForPolygon(pointLatNong, area);

    switch (attendanceType) {
      case AttendanceTypeEnum.checkIn:
        if (inRightArea) {
          if (isClosed) return;
          emit(AccessAbleAreaState());
        } else {
          if (isClosed) return;
          emit(AccessAbleAreaErrorState());
        }
        break;

      case AttendanceTypeEnum.checkOut:
        if (inRightArea) {
          emit(AccessAbleAreaState());
        } else {
          emit(AccessAbleAreaErrorState());
        }
        break;

      default:
        break;
    }
  }

  void checkAssessableAreaForCircle(LatLng pointLatNong, LatLng center,
      double radius, Enum attendanceType) async {
    bool isWithinCircle = employeeAttendanceRepo.checkAccessibleAreaForCircle(
            pointLatNong, center) <=
        radius;

    switch (attendanceType) {
      case AttendanceTypeEnum.checkIn:
        if (isWithinCircle) {
          emit(AccessAbleAreaState());
        } else {
          emit(AccessAbleAreaErrorState());
        }
        break;
      case AttendanceTypeEnum.checkOut:
        if (isWithinCircle) {
          emit(AccessAbleAreaState());
        } else {
          emit(AccessAbleAreaErrorState());
        }
        break;

      default:
        break;
    }
  }

  Future<void> setSelectedAttendanceTarget({
    required CustomerData target,
    required AttendanceTypeEnum attendanceType,
  }) async {
    selectedAttendanceTarget = target;
    customerId = target.id;
    if (isClosed) return;
    emit(AttendanceTargetSelected(target));
    if (currentUserLocation != null) {
      await validateSelectedAttendanceTarget(attendanceType: attendanceType);
    }
  }

  Future<void> updateCurrentLocation({
    required LatLng location,
    required AttendanceTypeEnum attendanceType,
  }) async {
    currentUserLocation = location;
    if (selectedAttendanceTarget != null) {
      await validateSelectedAttendanceTarget(attendanceType: attendanceType);
    }
  }

  Future<void> validateSelectedAttendanceTarget(
      {required AttendanceTypeEnum attendanceType}) async {
    final target = selectedAttendanceTarget;
    final userLocation = currentUserLocation;
    if (target == null || userLocation == null) {
      if (isClosed) return;
      emit(AccessAbleAreaErrorState());
      return;
    }

    final coordinates = target.coordinates ?? [];
    if (coordinates.isEmpty) {
      if (isClosed) return;
      emit(AccessAbleAreaErrorState());
      return;
    }

    if (target.customerType == CustomerType.Customer.name) {
      checkAssessableAreaForCircle(
        userLocation,
        LatLng(
          coordinates.first.latitude ?? 0,
          coordinates.first.longitude ?? 0,
        ),
        250,
        attendanceType,
      );
      return;
    }

    checkAssessableArea(
      userLocation,
      coordinates
          .map((coordinate) => LatLng(
                coordinate.latitude ?? 0,
                coordinate.longitude ?? 0,
              ))
          .toList(),
      attendanceType,
    );
  }

  Future<void> removeAssignCustomerPlan({required int customerPlanId}) async {
    emit(RemoveAssignCustomerPlanLoadingState());
    final result = await employeeAttendanceRepo.removeAssignCustomerPlan(
        removeAssignPlan: RemoveAssignCustomerPlanBody(
            customerPlanId: customerPlanId,
            employeeId: ApiConstant.employeeId));

    result.fold(
      (failure) {
        emit(RemoveAssignCustomerPlanFailureState(
          failure.message,
        ));
      },
      (success) {
        getCustomerArea();
        emit(RemoveAssignCustomerPlanSuccessState());
      },
    );
  }

  Future<void> getFeedBackStatus() async {
    switch (state) {
      case AccessAbleAreaState():
        emit(GetFeedBackStatusLoadingState());
        final result = await employeeAttendanceRepo.getFeedBackStatus();
        result.fold((failure) {
          emit(GetFeedBackStatusFailureState(
            failure.message,
          ));
        }, (success) {
          emit(GetFeedBackStatusSuccessState(
            success,
          ));
        });
        break;

      default:
        break;
    }
  }

  List<AttendanceCoordinate>? get _currentCoordinates {
    final location = currentUserLocation;
    if (location == null) return null;
    return [
      AttendanceCoordinate(
        latitude: location.latitude,
        longitude: location.longitude,
      ),
    ];
  }

  String _currentLocationLabel({required String area}) {
    final location = currentUserLocation;
    if (location != null) {
      return '${location.latitude},${location.longitude}';
    }
    return selectedAttendanceTarget?.location ?? area;
  }

  @override
  Future<void> close() {
    planFeedbackController.dispose();
    return super.close();
  }
}
