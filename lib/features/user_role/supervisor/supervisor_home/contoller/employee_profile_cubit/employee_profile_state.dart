part of 'employee_profile_cubit.dart';

@immutable
abstract class EmployeeProfileState {}

class EmployeeProfileInitial extends EmployeeProfileState {}

class GetEmployeeProfileLoading extends EmployeeProfileState {}

class GetEmployeeProfileSuccess extends EmployeeProfileState {
  final EmployeeProfileValue profile;

  GetEmployeeProfileSuccess({required this.profile});
}

class GetEmployeeProfileFailure extends EmployeeProfileState {
  final String error;

  GetEmployeeProfileFailure({required this.error});
}
