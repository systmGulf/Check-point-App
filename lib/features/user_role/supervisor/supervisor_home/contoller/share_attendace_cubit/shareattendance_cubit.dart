import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employees_attendance_model/get_employee_attendance.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:share_plus/share_plus.dart';

part 'shareattendance_state.dart';

class ShareattendanceCubit extends Cubit<ShareattendanceState> {
  ShareattendanceCubit() : super(ShareAttAndanceInitial());

  Future<void> exportAndShareExcel(
      List<SupervisorGetAllEmployeesAttendanceData> data) async {
    emit(ShareAttAndanceLoading());
    try {
      var excel = Excel.createExcel();
      var sheet = excel['Sheet1'];

      // Add headers
      sheet.appendRow([
        TextCellValue('Employee ID'),
        TextCellValue('Customer ID'),
        TextCellValue('Employee Name'),
        TextCellValue('Location'),
        TextCellValue('In Time'),
        TextCellValue('Out Time'),
        TextCellValue('Total Hours'),
        TextCellValue('Date'),
      ]);

      // Add data
      for (var item in data) {
        sheet.appendRow([
          TextCellValue(item.employeeId ?? ''),
          TextCellValue(item.customerId?.toString() ?? ''),
          TextCellValue(item.employeeName ?? ''),
          TextCellValue(item.area ?? ''),
          TextCellValue(item.clockInTime != null && item.clockInTime!.length >= 5 ? item.clockInTime!.substring(0, 5) : (item.clockInTime ?? '')),
          TextCellValue(item.clockOutTime != null && item.clockOutTime!.length >= 5 ? item.clockOutTime!.substring(0, 5) : (item.clockOutTime ?? '')),
          TextCellValue(item.totalHours?.toString() ?? ''),
          TextCellValue(item.attendanceDate ?? ''),
        ]);
      }

      List<int>? bytesList = excel.save();
      if (bytesList == null) {
        emit(ShareAttAndanceFailure(er: 'Failed to generate Excel file.'));
        return;
      }
      Uint8List bytes = Uint8List.fromList(bytesList);

      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              bytes,
              mimeType:
                  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            )
          ],
          text: 'Here is the employee attendance file for $formattedDate.',
          fileNameOverrides: ['Employee attendance $formattedDate.xlsx'],
        ),
      );

      emit(ShareAttAndanceSuccess());
    } catch (e) {
      emit(ShareAttAndanceFailure(er: e.toString()));
    }
  }
}
