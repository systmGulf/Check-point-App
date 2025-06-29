import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

part 'leave_application_state.dart';

class LeaveApplicationCubit extends Cubit<LeaveApplicationState> {
  final EmployeeActionRepo employeeRepo;
  LeaveApplicationCubit(this.employeeRepo) : super(LeaveApplicationInitial());
  TextEditingController reasonController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  String? employeeId;

  String from = '';
  String to = '';
  Future<void> sendRequestToSupervisor({required String type}) async {
    emit(AddLeaveApplicationLoading());
    if (from == '' || to == '') {
      emit(const AddLeaveApplicationFailure('please select date'));
      return;
    }
    final result = await employeeRepo.createLeaveRequest(
        LeaveRequestRequestBody(
            leaveRequestType: type,
            employeeId: employeeId ?? ApiConstant.employeeId,
            startDate: from,
            endDate: to,
            reason: reasonController.text,
            remark: remarkController.text));

    result.fold((l) {
      emit(AddLeaveApplicationFailure(l.message));
    }, (r) {
      emit(AddLeaveApplicationSuccess());
    });
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
