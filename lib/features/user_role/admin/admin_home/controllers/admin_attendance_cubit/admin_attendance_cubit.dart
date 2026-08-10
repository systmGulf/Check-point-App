import 'package:bloc/bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:meta/meta.dart';

import '../../../../../../core/common/attendance_report_formatter.dart';
import '../../../../../../core/common/excel_export_service.dart';

part 'admin_attendance_state.dart';

class AdminAttendanceCubit extends Cubit<AdminAttendanceState> {
  final ApiService apiService;

  AdminAttendanceCubit({required this.apiService})
      : super(AdminAttendanceInitial(DateTime.now()));

  void setSelectedDate(DateTime newDate) {
    emit(AdminAttendanceInitial(newDate));
    getAdminAttendance();
  }

  Future<void> getAdminAttendance() async {
    emit(AdminAttendanceLoading(state.selectedDate));
    try {
      final result = await apiService.get(
        endPoint: "Attendance?itemCount=1000&index=0",
      );
      if (result['isSuccess'] == true) {
        final attendanceModel = UserAttendanceModel.fromJson(result);
        if (!isClosed) {
          emit(AdminAttendanceSuccess(state.selectedDate, attendanceModel));
        }
      } else {
        if (!isClosed) {
          emit(AdminAttendanceFailure(state.selectedDate,
              result['successMessage'] ?? 'Failed to load attendance'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(AdminAttendanceFailure(state.selectedDate, e.toString()));
      }
    }
  }

  Future<void> exportAttendanceToExcel({
    required List<UserAttendanceData> allAttendance,
    required String rangeType,
  }) async {
    emit(AdminAttendanceExportLoading(state.selectedDate));
    try {
      List<UserAttendanceData> exportList = [];
      String fileNameSuffix = '';

      if (rangeType == 'daily') {
        final dateStr = state.selectedDate.toString().substring(0, 10);
        exportList = allAttendance
            .where((attendance) => attendance.attendanceDate == dateStr)
            .toList();
        fileNameSuffix = 'Daily_$dateStr';
      } else if (rangeType == 'weekly') {
        final startOfWeek = DateTime(state.selectedDate.year,
                state.selectedDate.month, state.selectedDate.day)
            .subtract(Duration(days: state.selectedDate.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 7));
        exportList = allAttendance.where((attendance) {
          final date = DateTime.tryParse(attendance.attendanceDate ?? '');
          if (date == null) return false;
          return date
                  .isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
              date.isBefore(endOfWeek);
        }).toList();
        final startStr = startOfWeek.toString().substring(0, 10);
        final endStr = endOfWeek
            .subtract(const Duration(days: 1))
            .toString()
            .substring(0, 10);
        fileNameSuffix = 'Weekly_${startStr}_to_${endStr}';
      } else if (rangeType == 'monthly') {
        exportList = allAttendance.where((attendance) {
          final date = DateTime.tryParse(attendance.attendanceDate ?? '');
          if (date == null) return false;
          return date.year == state.selectedDate.year &&
              date.month == state.selectedDate.month;
        }).toList();
        final monthStr =
            '${state.selectedDate.year}_${state.selectedDate.month.toString().padLeft(2, '0')}';
        fileNameSuffix = 'Monthly_$monthStr';
      }

      if (exportList.isEmpty) {
        if (!isClosed) {
          emit(AdminAttendanceExportFailure(state.selectedDate,
              'No attendance records found for the selected range.'));
        }
        return;
      }

      final excelService = ExcelExportService();
      final headers = [
        'Employee ID',
        'Customer ID',
        'Employee Name',
        'Location',
        'In Time',
        'Out Time',
        'Total Hours',
        'Date',
      ];
      final rows = exportList
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
        sheetName: 'Attendance',
        headers: headers,
        data: rows,
      );
      if (bytes == null) {
        if (!isClosed) {
          emit(AdminAttendanceExportFailure(
              state.selectedDate, 'Failed to generate Excel file.'));
        }
        return;
      }
      await excelService.shareExcel(
        fileBytes: bytes,
        fileName: 'Attendance_Report_$fileNameSuffix.xlsx',
        message: 'Here is the attendance report.',
      );
      if (!isClosed) {
        emit(AdminAttendanceExportSuccess(state.selectedDate));
      }
    } catch (e) {
      if (!isClosed) {
        emit(AdminAttendanceExportFailure(state.selectedDate, e.toString()));
      }
    }
  }

  Future<void> deleteAttendance(int id) async {
    emit(AdminAttendanceDeleteLoading(state.selectedDate));
    try {
      final result = await apiService.delete(
        endPoint: "Attendance/$id",
      );
      if (result['isSuccess'] == true) {
        if (!isClosed) {
          emit(AdminAttendanceDeleteSuccess(state.selectedDate));
        }
        // Refresh the list after successful deletion
        getAdminAttendance();
      } else {
        if (!isClosed) {
          emit(AdminAttendanceDeleteFailure(
            state.selectedDate,
            result['successMessage'] ?? 'Failed to delete attendance',
          ));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(AdminAttendanceDeleteFailure(state.selectedDate, e.toString()));
      }
    }
  }
}
