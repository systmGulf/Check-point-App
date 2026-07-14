import 'package:bloc/bloc.dart';
import 'package:employee_mangement/core/common/excel_export_service.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employees_attendance_model/get_employee_attendance.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'shareattendance_state.dart';

class ShareattendanceCubit extends Cubit<ShareattendanceState> {
  ShareattendanceCubit() : super(ShareAttAndanceInitial());

  Future<void> exportAndShareExcel(
      List<SupervisorGetAllEmployeesAttendanceData> data) async {
    emit(ShareAttAndanceLoading());
    try {
      final excelService = ExcelExportService();
      final rows = data
          .map((item) => [
                item.employeeId ?? '',
                item.customerId?.toString() ?? '',
                item.employeeName ?? '',
                item.area ?? '',
                item.clockInTime != null && item.clockInTime!.length >= 5
                    ? item.clockInTime!.substring(0, 5)
                    : (item.clockInTime ?? ''),
                item.clockOutTime != null && item.clockOutTime!.length >= 5
                    ? item.clockOutTime!.substring(0, 5)
                    : (item.clockOutTime ?? ''),
                item.totalHours?.toString() ?? '',
                item.attendanceDate ?? '',
              ])
          .toList();

      final bytes = excelService.generateExcel(
        sheetName: 'Attendance',
        headers: const [
          'Employee ID',
          'Customer ID',
          'Employee Name',
          'Location',
          'In Time',
          'Out Time',
          'Total Hours',
          'Date',
        ],
        data: rows,
      );

      if (bytes == null) {
        emit(ShareAttAndanceFailure(er: 'Failed to generate Excel file.'));
        return;
      }

      final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      await excelService.shareExcel(
        fileBytes: bytes,
        fileName: 'Employee_attendance_$formattedDate.xlsx',
        message: 'Here is the employee attendance file for $formattedDate.',
      );

      emit(ShareAttAndanceSuccess());
    } catch (e) {
      emit(ShareAttAndanceFailure(er: e.toString()));
    }
  }
}
