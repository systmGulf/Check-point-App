import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import '../../../../../../core/services/odoo_timeoff_service.dart';
import 'package:hr_management_system_package/core/common_methods/local_notifications_service.dart';

part 'leave_application_state.dart';

class LeaveApplicationCubit extends Cubit<LeaveApplicationState> {
  final EmployeeActionRepo employeeRepo;
  final OdooTimeOffService odooTimeOffService;

  LeaveApplicationCubit({
    required this.employeeRepo,
    required this.odooTimeOffService,
  }) : super(LeaveApplicationInitial());

  TextEditingController reasonController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  String? employee_id;
  String? get employeeId => employee_id;
  set employeeId(String? value) => employee_id = value;

  String from = '';
  String to = '';

  List<OdooLeaveType> leaveTypes = [];
  OdooLeaveType? selectedLeaveType;
  List<OdooPublicHoliday> publicHolidays = [];
  List<OdooLeaveRequest> odooRequests = [];

  Future<void> fetchLeaveTypes() async {
    emit(GetLeaveTypesLoading());
    try {
      final types = await odooTimeOffService.getLeaveTypes();
      leaveTypes = types;
      if (types.isNotEmpty && selectedLeaveType == null) {
        selectedLeaveType = types.first;
      }
      emit(GetLeaveTypesSuccess(types));
    } catch (e) {
      emit(GetLeaveTypesFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> fetchPublicHolidays({String? dateFrom, String? dateTo}) async {
    emit(GetPublicHolidaysLoading());
    try {
      final holidays = await odooTimeOffService.getPublicHolidays(
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      publicHolidays = holidays;
      emit(GetPublicHolidaysSuccess(holidays));

      // Trigger local notification if a holiday is today
      final today = DateTime.now();
      for (var holiday in holidays) {
        try {
          final from = DateTime.parse(holiday.dateFrom);
          final to = DateTime.parse(holiday.dateTo);
          final checkDay = DateTime(today.year, today.month, today.day);
          final start = DateTime(from.year, from.month, from.day);
          final end = DateTime(to.year, to.month, to.day);
          if (checkDay.compareTo(start) >= 0 && checkDay.compareTo(end) <= 0) {
            LocalNotificationService.showBasicNotification(
              title: 'Official Holiday Today 🌴',
              massBody: 'Today is ${holiday.name}. Enjoy your day off!',
            );
            break;
          }
        } catch (_) {}
      }
    } catch (e) {
      emit(GetPublicHolidaysFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> sendOdooLeaveRequest() async {
    emit(AddLeaveApplicationLoading());
    if (from.isEmpty || to.isEmpty) {
      emit(const AddLeaveApplicationFailure('please select date'));
      return;
    }
    if (selectedLeaveType == null) {
      emit(const AddLeaveApplicationFailure('please select a leave type'));
      return;
    }

    try {
      await odooTimeOffService.submitLeaveRequest(
        employee_id: employee_id ?? ApiConstant.employeeId,
        leaveTypeId: selectedLeaveType!.id,
        dateFrom: from,
        dateTo: to,
        reason: reasonController.text,
      );
      emit(AddLeaveApplicationSuccess());
    } catch (e) {
      emit(AddLeaveApplicationFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> fetchMyOdooLeaveRequests({String? stateFilter, int limit = 20}) async {
    emit(GetLeaveApplicationLoading());
    try {
      final reqs = await odooTimeOffService.getMyLeaveRequests(
        employee_id: employee_id ?? ApiConstant.employeeId,
        state: stateFilter,
        limit: limit,
      );
      odooRequests = reqs;
      emit(OdooGetLeaveRequestsSuccess(reqs));
    } catch (e) {
      emit(GetLeaveApplicationFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // Fallback / legacy methods kept for compatibility where necessary
  Future<void> sendRequestToSupervisor({required String type}) async {
    await sendOdooLeaveRequest();
  }

  Future<void> GetLeaveRequestByType({required String type}) async {
    await fetchMyOdooLeaveRequests();
  }

  Future<void> deleteLeaveRequest(
      {required int id, required String type}) async {
    emit(DeleteLeaveRequestLoading());
    final result = await employeeRepo.deleteLeaveRequest(id: id);
    result.fold((l) {
      emit(DeleteLeaveRequestFailure(l.message));
    }, (r) {
      fetchMyOdooLeaveRequests();
      emit(DeleteLeaveRequestSuccess());
    });
  }

  void changeAppLanguage(BuildContext context) {
    emit(ChangeAppLanguageLoading());
    Locale locale = EasyLocalization.of(context)!.locale;
    if (locale == const Locale('en', 'US')) {
      context.setLocale(const Locale('ar', 'AE'));
    } else {
      context.setLocale(const Locale('en', 'US'));
    }
    emit(ChangeAppLanguageSuccess());
  }

  Future<void> getEmployeesByDepartmentId() async {
    emit(GetEmployeesByDepartmentIdLoading());
    final result = await employeeRepo.getEmployeeByDepartmentId();
    result.fold((l) {
      emit(GetEmployeesByDepartmentIdFailure(l.message));
    }, (r) {
      emit(GetEmployeesByDepartmentIdSuccess(employees: r));
    });
  }
}
