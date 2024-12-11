part of 'tasks_cubit.dart';

@immutable
abstract class EmployeeTasksState {}

class TasksInitial extends EmployeeTasksState {}

class GetMyTasksSuccess extends EmployeeTasksState {
  final List<GetTasData> getTaskResponse;
  GetMyTasksSuccess(this.getTaskResponse);
}

class GetMyTasksLoading extends EmployeeTasksState {}

class GetMyTasksError extends EmployeeTasksState {
  final String error;
  GetMyTasksError(this.error);
}
