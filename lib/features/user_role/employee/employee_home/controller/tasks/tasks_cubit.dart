import 'package:bloc/bloc.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/organism/employee_leave_request_item.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_data.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/task_model/get_task_response.dart';

import 'package:meta/meta.dart';

part 'tasks_state.dart';

class EmployeeTasksCubit extends Cubit<EmployeeTasksState> {
  final EmployeeActionRepo employeeRepo;
  EmployeeTasksCubit(this.employeeRepo) : super(TasksInitial());
  String taskStatus = "Pending";
  // get employee tasks
  Future<void> getMyTasks() async {
    emit(GetMyTasksLoading());
    final result = await employeeRepo.getEmployeeTasks();
    result.fold((l) {
      emit(GetMyTasksError(l.message));
    }, (r) {
      emit(GetMyTasksSuccess(r));
    });
  }

  // update task Status
  Future<void> updateTaskStatus({required int taskId}) async {
    emit(UpdateTaskStatusLoading());
    final result =
        await employeeRepo.changeEmployeeTaskStatus(taskId: taskId, status: taskStatus);
    result.fold((l) {
      emit(UpdateTaskStatusError(l.message));
    }, (r) {
      getMyTasks();
      emit(UpdateTaskStatusSuccess());
    });
  }
}
