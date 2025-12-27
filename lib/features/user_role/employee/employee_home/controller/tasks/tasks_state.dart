part of 'tasks_cubit.dart';

@immutable
abstract class EmployeeTasksState {}

class TasksInitial extends EmployeeTasksState {}

class GetMyTasksSuccess extends EmployeeTasksState {
  final List<EmployeeTasks> getTaskResponse;
  GetMyTasksSuccess(this.getTaskResponse);
}

class GetMyTasksLoading extends EmployeeTasksState {}

class GetMyTasksError extends EmployeeTasksState {
  final String error;
  GetMyTasksError(this.error);
}

class UpdateTaskStatusLoading extends EmployeeTasksState {}

class UpdateTaskStatusError extends EmployeeTasksState {
  final String error;
  UpdateTaskStatusError(this.error);
}

class UpdateTaskStatusSuccess extends EmployeeTasksState {}
class DeleteEmployeeTaskSuccess extends EmployeeTasksState {}

class DeleteEmployeeTaskError extends EmployeeTasksState {
  final String error;
  DeleteEmployeeTaskError(this.error);
}

class DeleteEmployeeTaskLoading extends EmployeeTasksState {}
