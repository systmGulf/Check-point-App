part of 'department_cubit.dart';

@immutable
abstract class DepartmentState {}

class DepartmentInitial extends DepartmentState {}

class AddDepartmentLoading extends DepartmentState {}

class AddDepartmentSuccess extends DepartmentState {}

class AddDepartmentError extends DepartmentState {
  final String error;
  AddDepartmentError(this.error);
}

class GetDepartmentLoading extends DepartmentState {}

class GetDepartmentSuccess extends DepartmentState {
  final DepartmentValue departmentList;
  GetDepartmentSuccess(this.departmentList);
}

class GetDepartmentError extends DepartmentState {
  final String error;
  GetDepartmentError(this.error);
}

class SearchDepartmentLoading extends DepartmentState {}

class SearchDepartmentSuccess extends DepartmentState {
  final DepartmentValue departmentList;
  SearchDepartmentSuccess(this.departmentList);
}

class SearchDepartmentError extends DepartmentState {
  final String error;
  SearchDepartmentError(this.error);
}

class DeleteDepartmentLoading extends DepartmentState {}

class DeleteDepartmentSuccess extends DepartmentState {}

class DeleteDepartmentError extends DepartmentState {
  final String error;
  DeleteDepartmentError(this.error);
}

class EditDepartmentLoading extends DepartmentState {}

class EditDepartmentSuccess extends DepartmentState {}

class EditDepartmentError extends DepartmentState {
  final String error;
  EditDepartmentError(this.error);
}
