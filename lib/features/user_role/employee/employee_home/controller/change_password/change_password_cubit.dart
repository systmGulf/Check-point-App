import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

part 'change_password_state.dart';

class EmployeeChangePasswordCubit extends Cubit<EmployeeChangePasswordState> {
  final EmployeeActionRepo employeeRepo;
  EmployeeChangePasswordCubit(this.employeeRepo)
      : super(ChangePasswordInitial());
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  Future<void> changePassword() async {
    emit(ChangePasswordLoading());
    final result = await employeeRepo.employeeChangePassword(
        ChangePasswordRequestBody(
            employeeId: ApiConstant.employeeId,
            oldPassword: oldPasswordController.text,
            newPassword: newPasswordController.text));
    result.fold((l) {
      emit(ChangePasswordFailure(l.message));
    }, (r) {
      emit(ChangePasswordSuccess());
    });
  }
}
