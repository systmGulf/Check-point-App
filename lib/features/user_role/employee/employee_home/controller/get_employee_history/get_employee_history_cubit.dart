import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_attendance_repo/employee_attendance_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

part 'get_employee_history_state.dart';

class GetEmployeeHistoryCubit extends Cubit<GetEmployeeHistoryState> {
  final EmployeeAttendanceRepo employeeAttendanceRepo;
  GetEmployeeHistoryCubit(this.employeeAttendanceRepo)
      : super(GetEmployeeHistoryInitial());

  Future<void> getEmployeeHistory({int pageNumber = 0}) async {
    if (pageNumber == 0) {
      emit(GetEmployeeHistoryLoading());
    } else {
      emit(GetEmployeeHistoryPaginationLoading());
    }
    final result = await employeeAttendanceRepo.getAllEmployeeAttendance(
      pageNumber: pageNumber,
    );
    result.fold((l) {
      if (pageNumber == 0) {
        emit(GetEmployeeHistoryFailure(l.message));
      } else {
        emit(GetEmployeeHistoryPaginationFailure(l.message));
      }
    }, (value) {
      emit(GetEmployeeHistorySuccess(value));
    });
  }
}
