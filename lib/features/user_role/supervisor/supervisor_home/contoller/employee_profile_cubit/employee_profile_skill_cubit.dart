import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_profile_model/add_employee_skill_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_profile_model/skill_catalog_response.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/employee_summary_repo/employee_summary_repo.dart';

class EmployeeProfileSkillCubit extends Cubit<EmployeeProfileSkillState> {
  EmployeeProfileSkillCubit(this.employeeSummaryRepo)
      : super(const EmployeeProfileSkillState());

  final EmployeeSummaryRepo employeeSummaryRepo;

  Future<void> loadAllSkills() async {
    emit(
      state.copyWith(
        isLoadingSkills: true,
        clearErrorMessage: true,
        isSkillAdded: false,
      ),
    );

    final result = await employeeSummaryRepo.getAllSkills();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingSkills: false,
            errorMessage: failure.message,
          ),
        );
      },
      (skills) {
        emit(
          state.copyWith(
            isLoadingSkills: false,
            skills: skills,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> addSkill({
    required String employeeId,
    required String skillId,
    required int rate,
  }) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearSubmitErrorMessage: true,
        isSkillAdded: false,
      ),
    );

    final request = AddEmployeeSkillRequestBody(
      employeeId: employeeId,
      skillId: skillId,
      rate: rate,
    );

    final result = await employeeSummaryRepo.addUserSkill(body: request);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSubmitting: false,
            submitErrorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            isSubmitting: false,
            clearSubmitErrorMessage: true,
            isSkillAdded: true,
          ),
        );
      },
    );
  }

  void clearSkillAddedFlag() {
    if (state.isSkillAdded) {
      emit(state.copyWith(isSkillAdded: false));
    }
  }
}

@immutable
class EmployeeProfileSkillState {
  const EmployeeProfileSkillState({
    this.isLoadingSkills = false,
    this.isSubmitting = false,
    this.skills = const <SkillCatalogItem>[],
    this.errorMessage,
    this.submitErrorMessage,
    this.isSkillAdded = false,
  });

  final bool isLoadingSkills;
  final bool isSubmitting;
  final List<SkillCatalogItem> skills;
  final String? errorMessage;
  final String? submitErrorMessage;
  final bool isSkillAdded;

  EmployeeProfileSkillState copyWith({
    bool? isLoadingSkills,
    bool? isSubmitting,
    List<SkillCatalogItem>? skills,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? submitErrorMessage,
    bool clearSubmitErrorMessage = false,
    bool? isSkillAdded,
  }) {
    return EmployeeProfileSkillState(
      isLoadingSkills: isLoadingSkills ?? this.isLoadingSkills,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      skills: skills ?? this.skills,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      submitErrorMessage: clearSubmitErrorMessage
          ? null
          : (submitErrorMessage ?? this.submitErrorMessage),
      isSkillAdded: isSkillAdded ?? this.isSkillAdded,
    );
  }
}
