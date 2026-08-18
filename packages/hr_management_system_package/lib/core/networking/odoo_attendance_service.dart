import 'package:dio/dio.dart';

class OdooAttendanceService {
  final Dio _dio;

  OdooAttendanceService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://masteameg-newenlighten-test-36387693.dev.odoo.com',
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

  Future<bool> syncCheckIn({
    required String employeeIdStr,
    required String area,
  }) async {
    if (employeeIdStr.isEmpty) {
      print('Odoo sync skipped: employeeIdStr is empty');
      return false;
    }

    final String location = _getOdooLocation(area);

    print('--- ODOO SYNC CHECK-IN REQUEST ---');
    print('Url: ${_dio.options.baseUrl}/api/attendance/check_in');
    print('Headers: ${_dio.options.headers}');
    print('Body: {"mobile_employee_id": "$employeeIdStr", "location": "$location"}');

    try {
      final response = await _dio.post(
        '/api/attendance/check_in',
        queryParameters: {
          'mobile_employee_id': employeeIdStr,
          'location': location,
        },
      );
      print('--- ODOO SYNC CHECK-IN SUCCESS RESPONSE ---');
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data?['success'] ?? false;
    } on DioException catch (dioError) {
      print('--- ODOO SYNC CHECK-IN DIO ERROR ---');
      print('Status Code: ${dioError.response?.statusCode}');
      print('Error Message: ${dioError.message}');
      print('Response Data: ${dioError.response?.data}');
      return false;
    } catch (e) {
      print('--- ODOO SYNC CHECK-IN GENERAL ERROR ---');
      print('Error: $e');
      return false;
    }
  }

  Future<bool> syncCheckOut({
    required String employeeIdStr,
  }) async {
    if (employeeIdStr.isEmpty) {
      print('Odoo sync skipped: employeeIdStr is empty');
      return false;
    }

    print('--- ODOO SYNC CHECK-OUT REQUEST ---');
    print('Url: ${_dio.options.baseUrl}/api/attendance/check_out');
    print('Headers: ${_dio.options.headers}');
    print('Body: {"mobile_employee_id": "$employeeIdStr"}');

    try {
      final response = await _dio.post(
        '/api/attendance/check_out',
        queryParameters: {
          'mobile_employee_id': employeeIdStr,
        },
      );
      print('--- ODOO SYNC CHECK-OUT SUCCESS RESPONSE ---');
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data?['success'] ?? false;
    } on DioException catch (dioError) {
      print('--- ODOO SYNC CHECK-OUT DIO ERROR ---');
      print('Status Code: ${dioError.response?.statusCode}');
      print('Error Message: ${dioError.message}');
      print('Response Data: ${dioError.response?.data}');
      return false;
    } catch (e) {
      print('--- ODOO SYNC CHECK-OUT GENERAL ERROR ---');
      print('Error: $e');
      return false;
    }
  }
}
