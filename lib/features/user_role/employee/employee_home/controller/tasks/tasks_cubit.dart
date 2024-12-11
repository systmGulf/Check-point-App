import 'package:bloc/bloc.dart';
import 'package:hr_management_system_package/employee/data/repo/employee_data.dart';
import 'package:hr_management_system_package/supervisor/data/models/task_model/get_task_response.dart';
import 'package:meta/meta.dart';

part 'tasks_state.dart';

class EmployeeTasksCubit extends Cubit<EmployeeTasksState> {
  final EmployeeRepo employeeRepo;
  EmployeeTasksCubit(this.employeeRepo) : super(TasksInitial());

  Future<void> getMyTasks() async {
    emit(GetMyTasksLoading());
    final result = await employeeRepo.getMyTasks();
    result.fold((l) {
      emit(GetMyTasksError(l.message));
    }, (r) {
      emit(GetMyTasksSuccess(r));
    });
  }
}
