import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/supervisor/data/models/employees_attendance_model/get_employee_attendance.dart';
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
      Sheet sheet = excel['Sheet1'];

      // Add headers
      sheet.appendRow([
        'ID',
        'Employee Name',
        'Location',
        'In Time',
        'Out Time',
        'Total Hours'
      ]);

      // Add data
      for (var item in data) {
        sheet.appendRow([
          item.employeeId ?? '',
          item.employeeName ?? '',
          item.area ?? '',
          item.clockInTime?.substring(0, 5) ?? '',
          item.clockOutTime?.substring(0, 5) ?? '',
          item.totalHours.toString() ?? ''
        ]);
      }

      List<int>? bytesList = excel.save();
      if (bytesList == null) {
        emit(ShareAttAndanceFailure(er: 'Failed to generate Excel file.'));
        return;
      }
      Uint8List bytes = Uint8List.fromList(bytesList);

      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      await Share.shareXFiles(
          [
            XFile.fromData(
              bytes,
              mimeType:
                  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            )
          ],
          text: 'Here is the employee attendance file for $formattedDate.',
          fileNameOverrides: ['Employee attendance $formattedDate.xlsx']);

      emit(ShareAttAndanceSuccess());
    } catch (e) {
      emit(ShareAttAndanceFailure(er: e.toString()));
    }
  }
}
