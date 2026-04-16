part of 'leave_application_cubit.dart';

abstract class LeaveApplicationState extends Equatable {
  const LeaveApplicationState();

  @override
  List<Object> get props => [];
}

class LeaveApplicationInitial extends LeaveApplicationState {}

class GetLeaveTypesLoading extends LeaveApplicationState {}

class GetLeaveTypesSuccess extends LeaveApplicationState {
  final LeaveTypeResponse leaveTypeResponse;
  const GetLeaveTypesSuccess({required this.leaveTypeResponse});
}

class GetLeaveTypesFailure extends LeaveApplicationState {
  final String error;

  GetLeaveTypesFailure({required this.error});
}

class AddLeaveApplicationLoading extends LeaveApplicationState {}

class AddLeaveApplicationSuccess extends LeaveApplicationState {}

class AddLeaveApplicationFailure extends LeaveApplicationState {
  final String error;
  const AddLeaveApplicationFailure(this.error);
}

class GetLeaveApplicationLoading extends LeaveApplicationState {}

class GetLeaveApplicationSuccess extends LeaveApplicationState {
  final EmployeeLeaveRequestsModel employeeLeaveRequests;

  const GetLeaveApplicationSuccess({required this.employeeLeaveRequests});
}

class GetLeaveApplicationFailure extends LeaveApplicationState {
  final String error;
  const GetLeaveApplicationFailure(this.error);
}

class DeleteLeaveRequestLoading extends LeaveApplicationState {}

class DeleteLeaveRequestSuccess extends LeaveApplicationState {}

class DeleteLeaveRequestFailure extends LeaveApplicationState {
  final String error;
  const DeleteLeaveRequestFailure(this.error);
}

class ChangeAppLanguageLoading extends LeaveApplicationState {}

class ChangeAppLanguageSuccess extends LeaveApplicationState {}

class GetEmployeesByDepartmentIdFailure extends LeaveApplicationState {
  final String error;
  const GetEmployeesByDepartmentIdFailure(this.error);
}

class GetEmployeesByDepartmentIdSuccess extends LeaveApplicationState {
  final GetAllEmployeesValue employees;
  const GetEmployeesByDepartmentIdSuccess({required this.employees});
}

class GetEmployeesByDepartmentIdLoading extends LeaveApplicationState {}
