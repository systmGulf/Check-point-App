part of 'change_password_cubit.dart';

abstract class EmployeeChangePasswordState extends Equatable {
  const EmployeeChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordInitial extends EmployeeChangePasswordState {}

class ChangePasswordLoading extends EmployeeChangePasswordState {}

class ChangePasswordSuccess extends EmployeeChangePasswordState {}

class ChangePasswordFailure extends EmployeeChangePasswordState {
  final String errorMsg;
  const ChangePasswordFailure(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}
