import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/employee_check_in_request_body.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_summary_model/employee_summary_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_attendance_repo/supervisor_attendance_repo.dart';


part 'get_employees_data_state.dart';

class GetEmployeesDataCubit extends Cubit<GetEmployeesDataState> {
  final SupervisorAttendanceRepo supervisorRepo;
  GetEmployeesDataCubit({required this.supervisorRepo}) : super(GetEmployeesDataInitial());

  Future<void> getEmployeesByDepartmentId() async {
    emit(GetAllEmployeesLoading());
    final result = await supervisorRepo.getEmployeeByDepartmentId();
    result.fold(
      (error) {
        if (!isClosed) emit(GetAllEmployeesFailure(errorMsg: error.message));
      },
      (allEmployeesList) {
        if (!isClosed) emit(GetAllEmployeesSuccess(allEmployeesValue: allEmployeesList));
      },
    );
  }

  Future<void> supervisorAttendSomeEmployeeCheckIn(
      EmployeeCheckInRequestBody employeeCheckInRequestBody) async {
    emit(SupervisorAttendSomeEmployeeLoading());
    final result = await supervisorRepo
        .supervisorAttendSomeEmployeeCheckIn(employeeCheckInRequestBody);
    result.fold((l) {
      if (!isClosed) emit(SupervisorAttendSomeEmployeeFailure(errorMsg: l.message));
    }, (r) {
      if (!isClosed) emit(SupervisorAttendSomeEmployeeSuccess(
        successMsg: 'User Attended Successfully',
      ));
    });
  }

  Future<void> supervisorAttendSomeEmployeeCheckOut(String employeeId, String? image) async {
    emit(SupervisorAttendSomeEmployeeLoading());
    final result =
        await supervisorRepo.supervisorAttendSomeEmployeeCheckOut(employeeId, image);
    result.fold((l) {
      if (!isClosed) emit(SupervisorAttendSomeEmployeeFailure(errorMsg: l.message));
    }, (r) {
      if (!isClosed) emit(
        SupervisorAttendSomeEmployeeSuccess(
          successMsg: 'User Checked Out Successfully',
        ),
      );
    });
  }



  Future<void> getEmployeeSummaryByDepartmentId({
    required String employeeId,
    required int month,
    required int year,
  }) async {
    emit(GetEmployeeSummaryLoading());
    final result = await supervisorRepo.getEmployeeSummary(
        employeeId: employeeId, month: month, year: year);
    result.fold((l) {
      if (!isClosed) emit(GetEmployeeSummaryFailure(errorMsg: l.message));
    }, (r) {
      if (!isClosed) emit(GetEmployeeSummarySuccess(getEmployeeSummaryValue: r));
    });
  }
}
