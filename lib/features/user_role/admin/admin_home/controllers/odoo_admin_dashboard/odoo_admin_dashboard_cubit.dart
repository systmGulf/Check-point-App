import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/services/odoo_timeoff_service.dart';

part 'odoo_admin_dashboard_state.dart';

class OdooAdminDashboardCubit extends Cubit<OdooAdminDashboardState> {
  final OdooTimeOffService odooTimeOffService;

  OdooAdminDashboardCubit({required this.odooTimeOffService}) : super(OdooAdminDashboardInitial());

  String? selectedLocation;
  String? filterEmployeeId;
  String? dateFrom;
  String? dateTo;

  Future<void> fetchAdminDashboardData() async {
    emit(OdooAdminDashboardLoading());
    try {
      final results = await Future.wait([
        odooTimeOffService.getAllAttendance(
          employee_id: filterEmployeeId,
          location: selectedLocation,
          dateFrom: dateFrom,
          dateTo: dateTo,
        ),
        odooTimeOffService.getPublicHolidays(),
        odooTimeOffService.getLeaveTypes(),
      ]);

      final attendanceData = results[0] as Map<String, dynamic>;
      final rawLogs = attendanceData['attendances'] as List? ?? [];
      final attendances = rawLogs.map((e) => OdooAttendanceLog.fromJson(e)).toList();
      final totalCount = attendanceData['total_count'] as int? ?? 0;
      
      final publicHolidays = results[1] as List<OdooPublicHoliday>;
      final leaveTypes = results[2] as List<OdooLeaveType>;

      emit(OdooAdminDashboardSuccess(
        attendances: attendances,
        totalCount: totalCount,
        publicHolidays: publicHolidays,
        leaveTypes: leaveTypes,
      ));
    } catch (e) {
      emit(OdooAdminDashboardFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void updateFilters({String? employeeId, String? location, String? from, String? to}) {
    filterEmployeeId = employeeId;
    selectedLocation = location;
    dateFrom = from;
    dateTo = to;
    fetchAdminDashboardData();
  }

  void clearFilters() {
    filterEmployeeId = null;
    selectedLocation = null;
    dateFrom = null;
    dateTo = null;
    fetchAdminDashboardData();
  }
}
