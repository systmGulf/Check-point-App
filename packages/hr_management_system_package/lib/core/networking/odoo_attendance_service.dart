import 'package:dio/dio.dart';
import 'dart:developer' as developer;

class OdooAttendanceService {
  final Dio _dio;

  OdooAttendanceService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://masteameg-newenlighten-test-36134872.dev.odoo.com',
            headers: {
              'Accept': 'application/json',
              'API-KEY': 'jkashda_891273yubk_hjsda92',
            },
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

  String _getOdooLocation(String area) {
    switch (area.trim().toLowerCase()) {
      case 'office':
        return 'office';
      case 'customer':
        return 'customer';
      case 'site':
        return 'site';
      default:
        return 'site';
    }
  }

  Future<void> syncCheckIn({
    required String employeeIdStr,
    required String area,
  }) async {
    final int? employeeId = int.tryParse(employeeIdStr);
    if (employeeId == null) {
      developer.log('Odoo sync skipped: invalid numeric employeeId "$employeeIdStr"');
      return;
    }

    final String location = _getOdooLocation(area);

    try {
      developer.log('Syncing check-in to Odoo for employee $employeeId at $location');
      final response = await _dio.post(
        '/api/attendance/check_in',
        data: {
          'employee_id': employeeId,
          'location': location,
        },
      );
      developer.log('Odoo check-in sync response: ${response.data}');
    } catch (e) {
      developer.log('Odoo check-in sync failed: $e');
    }
  }

  Future<void> syncCheckOut({
    required String employeeIdStr,
  }) async {
    final int? employeeId = int.tryParse(employeeIdStr);
    if (employeeId == null) {
      developer.log('Odoo sync skipped: invalid numeric employeeId "$employeeIdStr"');
      return;
    }

    try {
      developer.log('Syncing check-out to Odoo for employee $employeeId');
      final response = await _dio.post(
        '/api/attendance/check_out',
        data: {
          'employee_id': employeeId,
        },
      );
      developer.log('Odoo check-out sync response: ${response.data}');
    } catch (e) {
      developer.log('Odoo check-out sync failed: $e');
    }
  }
}
