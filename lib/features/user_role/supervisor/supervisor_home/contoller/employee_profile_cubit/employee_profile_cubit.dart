import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/core/networking/api_constant.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_profile_model/employee_profile_response.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/employee_summary_repo/employee_summary_repo.dart';

part 'employee_profile_state.dart';

class EmployeeProfileCubit extends Cubit<EmployeeProfileState> {
  EmployeeProfileCubit(this.employeeSummaryRepo)
      : super(EmployeeProfileInitial());

  final EmployeeSummaryRepo employeeSummaryRepo;

  Future<void> getEmployeeProfile({String? employeeId}) async {
    final id = (employeeId ?? ApiConstant.employeeId).trim();

    if (id.isEmpty) {
      emit(GetEmployeeProfileFailure(error: 'Employee id not found'));
      return;
    }

    emit(GetEmployeeProfileLoading());
    final result = await employeeSummaryRepo.getEmployeeProfile(employeeId: id);

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(GetEmployeeProfileFailure(error: failure.message));
      },
      (profile) {
        if (isClosed) return;
        emit(GetEmployeeProfileSuccess(profile: profile));
      },
    );
  }
}
