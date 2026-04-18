import 'package:bloc/bloc.dart';

import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_tasks_reponse_model/employee_tasks_response_model.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_data.dart';
import 'package:meta/meta.dart';

part 'tasks_state.dart';

class EmployeeTasksCubit extends Cubit<EmployeeTasksState> {
  final EmployeeActionRepo employeeRepo;
  EmployeeTasksCubit(this.employeeRepo) : super(TasksInitial());

  // get employee tasks
  Future<void> getMyTasks() async {
    emit(GetMyTasksLoading());
    final result = await employeeRepo.getEmployeeTasks();
    result.fold((l) {
      emit(GetMyTasksError(l.message));
    }, (r) {
      print(r);
      emit(GetMyTasksSuccess(r.value!));
    });
  }

  // update task Status
  Future<void> updateTaskStatus(
      {required String employeeTaskId, required int state}) async {
    emit(UpdateTaskStatusLoading());
    final result = await employeeRepo.changeEmployeeTaskStatus(
      employeeTaskId: employeeTaskId,
      state: state,
    );
    result.fold((l) {
      emit(UpdateTaskStatusError(l.message));
    }, (r) {
      getMyTasks();
      emit(UpdateTaskStatusSuccess());
    });
  }

  // delete task
  Future<void> deleteTask({required String employeeTaskId}) async {
    emit(DeleteEmployeeTaskLoading());
    final result = await employeeRepo.deleteTask(
      employeeTaskId: employeeTaskId,
    );
    result.fold((l) {
      emit(DeleteEmployeeTaskError(l.message));
    }, (r) {
      getMyTasks();
      emit(DeleteEmployeeTaskSuccess());
    });
  }
}
