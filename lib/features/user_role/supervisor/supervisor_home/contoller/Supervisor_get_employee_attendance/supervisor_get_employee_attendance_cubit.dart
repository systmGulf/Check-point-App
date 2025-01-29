import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/employee/data/models/user_attendace_model/user_tracking_summary_response_model.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:hr_management_system_package/supervisor/data/models/customers/get_customer_by_id_model.dart';
import 'package:hr_management_system_package/supervisor/data/models/employees_attendance_model/get_employee_attendance.dart';

part 'supervisor_get_employee_attendance_state.dart';

class SupervisorGetEmployeeAttendanceCubit
    extends Cubit<SupervisorGetEmployeeAttendanceState> {
  final SupervisorRepo supervisorRepo;

  SupervisorGetEmployeeAttendanceCubit(this.supervisorRepo)
      : super(SupervisorGetEmployeeAttendanceInitial(DateTime.now()));
  // SUPERVISOR GET EMPLOYEE ATTENDANCE
  Future<void> supervisorGetEmployeesAttendanceByDepartmentId() async {
    emit(SupervisorGetEmployeeAttendanceLoading(state.selectedDate));
    final result = await supervisorRepo.getEmployeeAttendanceByDepartmentId(
      attendanceDate: state.selectedDate.toString().substring(0, 10),
    );
    result.fold(
      (error) {
        if (isClosed) return;
        emit(SupervisorGetEmployeeAttendanceFailure(
            state.selectedDate, error.message));
      },
      (employeeAllAttendance) {
        if (isClosed) return;
        emit(SupervisorGetEmployeeAttendanceSuccess(
            state.selectedDate, employeeAllAttendance));
      },
    );
  }

  // Set Selected Date
  void setSelectedDate(DateTime newDate) {
    emit(SupervisorGetEmployeeAttendanceInitial(newDate));
    supervisorGetEmployeesAttendanceByDepartmentId();
  }

  // SUPERVISOR GET LATE COMERS
  Future<void> supervisorGetLateComers() async {
    emit(SupervisorGetLateComersLoading(state.selectedDate));
    final result = await supervisorRepo.supervisorGetLateComers(
        day: state.selectedDate.toString().substring(0, 10));
    result.fold(
      (error) {
        if (isClosed) return;
        emit(SupervisorGetLateComersFailure(state.selectedDate, error.message));
      },
      (employeeAllAttendance) {
        if (isClosed) return;
        emit(SupervisorGetLateComersSuccess(
            state.selectedDate, employeeAllAttendance));
      },
    );
  }

  // SUPERVISOR GET EARLY LEAVERS
  Future<void> supervisorGetEarlyLeavers() async {
    emit(SupervisorGetEarlyLeaversLoading(state.selectedDate));
    final result = await supervisorRepo.supervisorGetEarlyLeavers(
        day: state.selectedDate.toString().substring(0, 10));
    result.fold(
      (error) {
        if (isClosed) return;
        emit(SupervisorGetEarlyLeaversFailure(
            state.selectedDate, error.message));
      },
      (employeeAllAttendance) {
        if (isClosed) return;
        emit(SupervisorGetEarlyLeaversSuccess(
            state.selectedDate, employeeAllAttendance));
      },
    );
  }

  // get Customr in Attendance
  Future<void> supervisorGetCustomerInAttendance(
      {required String CustomerId}) async {
    emit(GetCustomerCustomerInAttendanceLoading(state.selectedDate));
    final result = await supervisorRepo.getCustomerById(CustomerId: CustomerId);
    result.fold((error) {
      if (isClosed) return;
      emit(GetCustomerCustomerInAttendanceFailure(
          state.selectedDate, error.message));
    }, (employeeAllAttendance) {
      if (isClosed) return;
      emit(GetCustomerCustomerInAttendanceSuccess(
          state.selectedDate, employeeAllAttendance));
    });
  }

  // get Tracking Summary For employee
  Future<void> supervisorGetTrackingSummaryForEmployee({
    required String employeeId,
  }) async {
    emit(GetEmployeeTrackingSummaryLoading(state.selectedDate));
    final result = await supervisorRepo.getTrackingSummaryForEmployee(
        employeeId: employeeId,
        data: state.selectedDate.toString().substring(0, 10));
    result.fold((error) {
      if (isClosed) return;
      emit(
          GetEmployeeTrackingSummaryFailure(state.selectedDate, error.message));
    }, (employeeAllAttendance) {
      if (isClosed) return;
      emit(GetEmployeeTrackingSummarySuccess(
          state.selectedDate, employeeAllAttendance));
    });
  }
}
