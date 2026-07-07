import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/core/networking/api_constant.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_tasks_reponse_model/employee_tasks_response_model.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_data.dart';

part 'tasks_state.dart';

class EmployeeTasksCubit extends Cubit<EmployeeTasksState> {
  EmployeeTasksCubit({required this.employeeRepo}) : super(TasksInitial());

  final EmployeeActionRepo employeeRepo;

  Future<void> getMyTasks() async {
    emit(GetMyTasksLoading());
    final result = await employeeRepo.getEmployeeTasks();
    result.fold(
      (l) {
        if (!isClosed) emit(GetMyTasksError(l.message));
      },
      (r) {
        if (!isClosed) emit(GetMyTasksSuccess(r.value!.employeeTasks!));
      },
    );
  }

  Future<void> updateTaskStatus({
    required int taskId,
    required String taskStatus,
  }) async {
    emit(UpdateTaskStatusLoading());
    final result = await employeeRepo.changeEmployeeTaskStatus(
      taskId: taskId,
      status: taskStatus,
    );
    result.fold(
      (l) {
        if (!isClosed) emit(UpdateTaskStatusError(l.message));
      },
      (r) {
        if (!isClosed) emit(UpdateTaskStatusSuccess());
        getMyTasks();
      },
    );
  }

  Future<void> deleteTask({required int taskId}) async {
    emit(DeleteEmployeeTaskLoading());
    final result = await employeeRepo.deleteTask(
      taskId: taskId,
      employeeId: '${ApiConstant.employeeId}',
    );
    result.fold(
      (l) {
        if (!isClosed) emit(DeleteEmployeeTaskError(l.message));
      },
      (r) {
        if (!isClosed) emit(DeleteEmployeeTaskSuccess());
        getMyTasks();
      },
    );
  }
}
