import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import '../../../../../../core/services/odoo_timeoff_service.dart';

part 'odoo_dashboard_state.dart';

class OdooDashboardCubit extends Cubit<OdooDashboardState> {
  final OdooTimeOffService odooTimeOffService;

  OdooDashboardCubit({required this.odooTimeOffService}) : super(OdooDashboardInitial());

  String period = 'month';

  Future<void> fetchDashboardData() async {
    emit(OdooDashboardLoading());
    try {
      final employeeId = ApiConstant.employeeId;
      
      // Fetch status, attendance data, and leave requests in parallel
      final results = await Future.wait([
        odooTimeOffService.getAttendanceStatus(employee_id: employeeId),
        odooTimeOffService.getMyAttendance(employee_id: employeeId, period: period),
        odooTimeOffService.getMyLeaveRequests(employee_id: employeeId),
      ]);

      final status = results[0] as Map<String, dynamic>;
      final attendanceData = results[1] as OdooMyAttendanceData;
      final leaveRequests = results[2] as List<OdooLeaveRequest>;

      emit(OdooDashboardSuccess(
        status: status,
        attendanceData: attendanceData,
        leaveRequests: leaveRequests,
      ));
    } catch (e) {
      emit(OdooDashboardFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void changePeriod(String newPeriod) {
    period = newPeriod;
    fetchDashboardData();
  }
}
