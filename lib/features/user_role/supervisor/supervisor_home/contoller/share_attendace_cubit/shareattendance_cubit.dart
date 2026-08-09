import 'package:bloc/bloc.dart';
import 'package:employee_mangement/core/common/attendance_report_formatter.dart';
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
                AttendanceReportFormatter.formatEmployeeId(item.employeeId),
                AttendanceReportFormatter.formatCustomerId(item.customerId?.toString()),
                item.employeeName ?? '-',
                item.area ?? 'Office',
                AttendanceReportFormatter.formatTime(item.clockInTime),
                AttendanceReportFormatter.formatTime(item.clockOutTime, isOutTime: true),
                AttendanceReportFormatter.formatTotalHours(item.totalHours),
                item.attendanceDate ?? '-',
              ])
          .toList();

      final bytes = excelService.generateExcel(
        sheetName: 'Attendance Report',
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
        fileName: 'Employee_Attendance_Report_$formattedDate.xlsx',
        message: 'Here is the professional employee attendance report for $formattedDate.',
      );

      emit(ShareAttAndanceSuccess());
    } catch (e) {
      emit(ShareAttAndanceFailure(er: e.toString()));
    }
  }
}
