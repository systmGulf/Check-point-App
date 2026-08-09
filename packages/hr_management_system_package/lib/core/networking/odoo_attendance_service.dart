import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final String? odooEmpIdStr = prefs.getString('odoo_employee_id');
    
    if (odooEmpIdStr == null || odooEmpIdStr.isEmpty) {
      print('Odoo sync skipped: odoo_employee_id not set in SharedPreferences');
      return;
    }

    final int? employeeId = int.tryParse(odooEmpIdStr);
    if (employeeId == null) {
      print('Odoo sync skipped: invalid numeric odoo_employee_id "$odooEmpIdStr"');
      return;
    }

    final String location = _getOdooLocation(area);

    print('--- ODOO SYNC CHECK-IN REQUEST ---');
    print('Url: ${_dio.options.baseUrl}/api/attendance/check_in');
    print('Headers: ${_dio.options.headers}');
    print('Body: {"employee_id": $employeeId, "location": "$location"}');

    try {
      final response = await _dio.post(
        '/api/attendance/check_in',
        data: {
          'employee_id': employeeId,
          'location': location,
        },
      );
      print('--- ODOO SYNC CHECK-IN SUCCESS RESPONSE ---');
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
    } on DioException catch (dioError) {
      print('--- ODOO SYNC CHECK-IN DIO ERROR ---');
      print('Status Code: ${dioError.response?.statusCode}');
      print('Error Message: ${dioError.message}');
      print('Response Data: ${dioError.response?.data}');
    } catch (e) {
      print('--- ODOO SYNC CHECK-IN GENERAL ERROR ---');
      print('Error: $e');
    }
  }

  Future<void> syncCheckOut({
    required String employeeIdStr,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? odooEmpIdStr = prefs.getString('odoo_employee_id');
    
    if (odooEmpIdStr == null || odooEmpIdStr.isEmpty) {
      print('Odoo sync skipped: odoo_employee_id not set in SharedPreferences');
      return;
    }

    final int? employeeId = int.tryParse(odooEmpIdStr);
    if (employeeId == null) {
      print('Odoo sync skipped: invalid numeric odoo_employee_id "$odooEmpIdStr"');
      return;
    }

    print('--- ODOO SYNC CHECK-OUT REQUEST ---');
    print('Url: ${_dio.options.baseUrl}/api/attendance/check_out');
    print('Headers: ${_dio.options.headers}');
    print('Body: {"employee_id": $employeeId}');

    try {
      final response = await _dio.post(
        '/api/attendance/check_out',
        data: {
          'employee_id': employeeId,
        },
      );
      print('--- ODOO SYNC CHECK-OUT SUCCESS RESPONSE ---');
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
    } on DioException catch (dioError) {
      print('--- ODOO SYNC CHECK-OUT DIO ERROR ---');
      print('Status Code: ${dioError.response?.statusCode}');
      print('Error Message: ${dioError.message}');
      print('Response Data: ${dioError.response?.data}');
    } catch (e) {
      print('--- ODOO SYNC CHECK-OUT GENERAL ERROR ---');
      print('Error: $e');
    }
  }
}
