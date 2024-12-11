part of 'get_employees_data_cubit.dart';

@immutable
sealed class GetEmployeesDataState {}

final class GetEmployeesDataInitial extends GetEmployeesDataState {}

class GetAllEmployeesLoading extends GetEmployeesDataState {}

class GetAllEmployeesSuccess extends GetEmployeesDataState {
  final GetAllEmployeesValue allEmployeesValue;

  GetAllEmployeesSuccess({required this.allEmployeesValue});
}

class GetAllEmployeesFailure extends GetEmployeesDataState {
  final String errorMsg;

  GetAllEmployeesFailure({required this.errorMsg});
}

class SupervisorAttendSomeEmployeeLoading extends GetEmployeesDataState {}

class SupervisorAttendSomeEmployeeSuccess extends GetEmployeesDataState {
  final String successMsg;

  SupervisorAttendSomeEmployeeSuccess({required this.successMsg});
}

class SupervisorAttendSomeEmployeeFailure extends GetEmployeesDataState {
  final String errorMsg;

  SupervisorAttendSomeEmployeeFailure({required this.errorMsg});
}

class GetEmployeeSummaryLoading extends GetEmployeesDataState {}

class GetEmployeeSummarySuccess extends GetEmployeesDataState {
  final EmployeeSummaryValue getEmployeeSummaryValue;

  GetEmployeeSummarySuccess({required this.getEmployeeSummaryValue});
}

class GetEmployeeSummaryFailure extends GetEmployeesDataState {
  final String errorMsg;

  GetEmployeeSummaryFailure({required this.errorMsg});
}
