import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/core/networking/api_constant.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_profile_model/employee_profile_response.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_profile_model/update_employee_profile_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_profile_model/user_skills_response.dart';
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
    final profileResult = await employeeSummaryRepo.getEmployeeProfile(
      employeeId: id,
    );
    final skillsResult =
        await employeeSummaryRepo.getUserSkills(employeeId: id);

    profileResult.fold(
      (failure) {
        if (isClosed) return;
        emit(GetEmployeeProfileFailure(error: failure.message));
      },
      (profile) {
        if (isClosed) return;
        final skills = skillsResult.fold<List<UserSkillItem>>(
          (_) => <UserSkillItem>[],
          (items) => items,
        );
        emit(GetEmployeeProfileSuccess(profile: profile, userSkills: skills));
      },
    );
  }

  Future<String?> updateEmployeeProfile({
    String? employeeId,
    required UpdateEmployeeProfileRequestBody body,
  }) async {
    final id = (employeeId ?? ApiConstant.employeeId).trim();

    if (id.isEmpty) {
      return 'Employee id not found';
    }

    final result = await employeeSummaryRepo.updateEmployeeProfile(
      employeeId: id,
      body: body,
    );

    return result.fold((failure) => failure.message, (_) => null);
  }
}
