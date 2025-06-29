part of 'tasks_cubit.dart';

@immutable
abstract class TasksState {}

class TasksInitial extends TasksState {}

class AddTaskLoading extends TasksState {}

class AddTaskSuccess extends TasksState {}

class AddTaskError extends TasksState {
  final String errorMessage;

  AddTaskError({required this.errorMessage});
}

class GetTasksLoading extends TasksState {}

class GetTasksSuccess extends TasksState {
  final  List<GetTasData> tasks;

  GetTasksSuccess({required this.tasks});
}

class GetTasksError extends TasksState {
  final String errorMessage;

  GetTasksError({required this.errorMessage});
}
class GetTaskPaginationLoading extends TasksState {}
class GetTaskPaginationFailure extends TasksState {
  final String errorMessage;
  GetTaskPaginationFailure({required this.errorMessage});
}

class DeleteTaskSuccess extends TasksState {}

class DeleteTaskError extends TasksState {
  final String errorMessage;
  DeleteTaskError({required this.errorMessage});
}

class DeleteTaskLoading extends TasksState {}
class AssignTaskLoading extends TasksState {}
class AssignTaskSuccess extends TasksState {}
class AssignTaskError extends TasksState {
  final String errorMessage;

  AssignTaskError({required this.errorMessage});  
}

class ChangeTaskStatusLoading extends TasksState {}
class ChangeTaskStatusSuccess extends TasksState {}
class ChangeTaskStatusError extends TasksState {
  final String errorMessage;
  ChangeTaskStatusError({required this.errorMessage});
}