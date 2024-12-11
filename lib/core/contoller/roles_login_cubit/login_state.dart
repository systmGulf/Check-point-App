part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final dynamic employeeLoginModel;

  LoginSuccess({required this.employeeLoginModel});
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}
class GetEmployeeLoading extends LoginState {}
class GetEmployeeSuccess extends LoginState {
  final EmployeeData employeeLoginModel;
  GetEmployeeSuccess({required this.employeeLoginModel});
}

class GetEmployeeFailure extends LoginState {
  final String error;
  GetEmployeeFailure({required this.error});
}
