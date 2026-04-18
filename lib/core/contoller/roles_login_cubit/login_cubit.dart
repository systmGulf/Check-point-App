import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo employeeLoginRepo;
  LoginCubit(this.employeeLoginRepo) : super(LoginInitial());
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  Future<void> doLogin({
    required String role,
  }) async {
    emit(LoginLoading());
    try {
      final result = await employeeLoginRepo.roleLogin(RoleLoginRequestBody(
        emailOrPhone: emailController.text,
        password: passwordTextController.text,
      ));
      result.fold((failure) {
        emit(LoginFailure(error: failure.message));
      }, (employeeLoginModel) {
        emit(LoginSuccess(employeeLoginModel: employeeLoginModel));
      });
    } catch (e) {
      final message = e.toString();
      if (message.contains('Status: 302') ||
          message.contains('DioExceptionType.badResponse')) {
        emit(LoginFailure(
            error:
                'Login request failed (302). Please check API base URL, endpoint/proxy config, and backend redirect rules.'));
        return;
      }
      emit(LoginFailure(error: 'Unexpected login error. Please try again.'));
    }
  }

  Future<void> getEmployeeById() async {
    emit(GetEmployeeLoading());
    try {
      final result = await employeeLoginRepo.getEmployeeById();
      result.fold((failure) {
        emit(GetEmployeeFailure(error: failure.message));
      }, (employeeLoginModel) {
        emit(GetEmployeeSuccess(employeeLoginModel: employeeLoginModel));
      });
    } catch (_) {
      emit(GetEmployeeFailure(
          error: 'Unexpected error while loading employee profile.'));
    }
  }
}
