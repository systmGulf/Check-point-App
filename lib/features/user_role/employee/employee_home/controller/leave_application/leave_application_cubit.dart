import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/core/networking/api_constant.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_leave_requests_models/employee_leave_requests.dart'
    show EmployeeLeaveRequestsModel;
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_leave_requests_models/leave_request_request_body.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_leave_requests_models/leave_types_response.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_leave_requests_repo/employee_action_repo.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/employee_model/all_employees_model.dart';

part 'leave_application_state.dart';

class LeaveApplicationCubit extends Cubit<LeaveApplicationState> {
  final EmployeeActionRepo employeeRepo;
  LeaveApplicationCubit(this.employeeRepo) : super(LeaveApplicationInitial());
  TextEditingController reasonController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emergencyEmailController = TextEditingController();
  TextEditingController emergencyPhoneController = TextEditingController();
  String? employeeId;

  String from = '';
  String to = '';

  Future<void> getLeaveTypes() async {
    emit(GetLeaveTypesLoading());
    final result = await employeeRepo.getLeaveTypes();
    result.fold((l) {
      emit(GetLeaveTypesFailure(error: l.message));
    }, (r) {
      emit(GetLeaveTypesSuccess(leaveTypeResponse: r));
    });
  }

  Future<void> sendRequestToSupervisor({required String leaveTypeId}) async {
    emit(AddLeaveApplicationLoading());
    if (from == '' || to == '') {
      emit(const AddLeaveApplicationFailure('please select date'));
      return;
    }
    if (numberController.text.trim().isEmpty ||
        emergencyEmailController.text.trim().isEmpty ||
        emergencyPhoneController.text.trim().isEmpty) {
      emit(
        const AddLeaveApplicationFailure(
          'Please fill all required contact fields',
        ),
      );
      return;
    }
    try {
      final requestor = employeeId ?? ApiConstant.employeeId;
      final result = await employeeRepo.createLeaveRequest(
        LeaveRequestRequestBody(
          requestorId: requestor,
          requestorName: ApiConstant.username,
          number: numberController.text.trim(),
          reason: reasonController.text.trim(),
          leavePeriod: LeavePeriod(
            startDate: from,
            endDate: to,
          ),
          emergencyInfo: EmergencyInfo(
            email: emergencyEmailController.text.trim(),
            phone: emergencyPhoneController.text.trim(),
          ),
          leaveTypeId: leaveTypeId,
          status: 1,
        ),
      );

      result.fold((l) {
        emit(AddLeaveApplicationFailure(l.message));
      }, (r) {
        emit(AddLeaveApplicationSuccess());
      });
    } catch (_) {
      emit(
        const AddLeaveApplicationFailure(
          'Unexpected server response while creating leave request',
        ),
      );
    }
  }

  Future<void> GetLeaveRequestByType({required String type}) async {
    emit(GetLeaveApplicationLoading());
    final result =
        await employeeRepo.getLeaveRequestsByTypeForEmployee(type: type);
    result.fold((l) {
      emit(GetLeaveApplicationFailure(l.message));
    }, (r) {
      emit(GetLeaveApplicationSuccess(employeeLeaveRequests: r));
    });
  }

  Future<void> deleteLeaveRequest(
      {required int id, required String type}) async {
    emit(DeleteLeaveRequestLoading());
    final result = await employeeRepo.deleteLeaveRequest(id: id);
    result.fold((l) {
      emit(DeleteLeaveRequestFailure(l.message));
    }, (r) {
      GetLeaveRequestByType(type: type);
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
