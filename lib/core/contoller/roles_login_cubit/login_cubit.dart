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

  Future<void> doLogin() async {
    emit(LoginLoading());

    final result = await employeeLoginRepo.roleLogin(RoleLoginRequestBody(
      emailOrPhone: emailController.text,
      password: passwordTextController.text,
    ));
    result.fold((failure) {
      emit(LoginFailure(error: failure.message));
    }, (employeeLoginModel) {
      emit(LoginSuccess(employeeLoginModel: employeeLoginModel));
    });
  }

  Future<void> getEmployeeById() async {
    emit(GetEmployeeLoading());
    final result = await employeeLoginRepo.getEmployeeById();
    result.fold((failure) {
      emit(GetEmployeeFailure(error: failure.message));
    }, (employeeLoginModel) {
      emit(GetEmployeeSuccess(employeeLoginModel: employeeLoginModel));
    });
  }
}
