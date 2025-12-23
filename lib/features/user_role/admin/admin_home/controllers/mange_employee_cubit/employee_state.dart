part of 'employee_cubit.dart';

@immutable
abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class AddEmployeeLoading extends EmployeeState {}

class AddEmployeeSuccess extends EmployeeState {}

class AddEmployeeFailure extends EmployeeState {
  final String error;
  AddEmployeeFailure({required this.error});
}

class GetAllEmployeesLoading extends EmployeeState {}

class GetAllEmployeesSuccess extends EmployeeState {
  final GetAllEmployeesValue value;
  GetAllEmployeesSuccess({required this.value});
}
class GetAllEmployeesPaginationLoading extends EmployeeState {}
class SearchEmployeeLoading extends EmployeeState {}
class SearchEmployeeSuccess extends EmployeeState {
  final GetAllEmployeesValue employeeList;
  SearchEmployeeSuccess({required this.employeeList});

}
class SearchEmployeeFailure extends EmployeeState {
  final String error;
  SearchEmployeeFailure({required this.error});
}
class GetAllEmployeesPaginationFailure extends EmployeeState {
  final String error;
  GetAllEmployeesPaginationFailure({required this.error});
}
class GetAllEmployeesFailure extends EmployeeState {
  final String error;
  GetAllEmployeesFailure({required this.error});
}

class DeleteUserAccountLoading extends EmployeeState {}

class DeleteUserAccountSuccess extends EmployeeState {}

class DeleteUserAccountFailure extends EmployeeState {
  final String error;
  DeleteUserAccountFailure({required this.error});
}

class EditEmployeeLoading extends EmployeeState {}

class EditEmployeeSuccess extends EmployeeState {}

class EditEmployeeFailure extends EmployeeState {
  final String error;
  EditEmployeeFailure({required this.error});
}

class GetEmployeeByDepartmentLoading extends EmployeeState {}

class GetEmployeeByDepartmentSuccess extends EmployeeState {
  final GetEmployeesInDepartmentValue employeeList;
  GetEmployeeByDepartmentSuccess(this.employeeList);
}

class GetEmployeeByDepartmentError extends EmployeeState {
  final String error;
  GetEmployeeByDepartmentError(this.error);
}

class AttendAntherEmployeePermissionLoading extends EmployeeState {}

class AttendAntherEmployeePermissionSuccess extends EmployeeState {}

class AttendAntherEmployeePermissionFailure extends EmployeeState {
  final String error;
  AttendAntherEmployeePermissionFailure(this.error);
}

class SetPlanPermissionLoading extends EmployeeState {}

class SetPlanPermissionSuccess extends EmployeeState {}

class SetPlanPermissionFailure extends EmployeeState {
  final String errorMessage;
  SetPlanPermissionFailure(this.errorMessage);
}

class GetAddAccountRequestsLoading extends EmployeeState {}

class GetAddAccountRequestsSuccess extends EmployeeState {
  final AddAccountRequestValue value;
  GetAddAccountRequestsSuccess({required this.value});
}

class GetAddAccountRequestsFailure extends EmployeeState {
  final String error;
  GetAddAccountRequestsFailure({required this.error});
}

class DeleteAddAccountRequestLoading extends EmployeeState {}

class DeleteAddAccountRequestSuccess extends EmployeeState {}

class DeleteAddAccountRequestFailure extends EmployeeState {
  final String error;
  DeleteAddAccountRequestFailure({required this.error});
}
