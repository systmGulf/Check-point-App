import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../networking/api_constant.dart';

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

  // Resolve Odoo employee ID by searching active attendances by name
  Future<int?> _resolveEmployeeIdByName(String name) async {
    if (name.isEmpty) return null;
    
    try {
      print('Odoo Auto-Sync: Searching Odoo for employee name "$name"...');
      final response = await _dio.get('/api/attendance/all', queryParameters: {'limit': 500});
      
      if (response.statusCode == 200 && response.data != null) {
        final success = response.data['success'] ?? false;
        if (success) {
          final attendances = response.data['data']?['attendances'] as List?;
          if (attendances != null) {
            final String normalizedTarget = name.trim().toLowerCase();
            
            for (var att in attendances) {
              final String? empName = att['employee_name']?.toString().trim().toLowerCase();
              if (empName == normalizedTarget) {
                final int? resolvedId = att['employee_id'] as int?;
                if (resolvedId != null) {
                  print('Odoo Auto-Sync: Found matching employee "$name" with Odoo ID: $resolvedId');
                  return resolvedId;
                }
              }
            }
          }
        }
      }
      print('Odoo Auto-Sync: No matching employee name "$name" found in Odoo attendance logs.');
    } catch (e) {
      print('Odoo Auto-Sync: Failed to resolve employee ID by name: $e');
    }
    return null;
  }

  Future<int?> _getOrResolveEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Try reading manual or previously cached ID
    final String? cachedIdStr = prefs.getString('odoo_employee_id');
    if (cachedIdStr != null && cachedIdStr.isNotEmpty) {
      final int? cachedId = int.tryParse(cachedIdStr);
      if (cachedId != null) {
        return cachedId;
      }
    }

    // 2. Resolve automatically by matching username
    final String name = ApiConstant.username;
    final int? resolvedId = await _resolveEmployeeIdByName(name);
    if (resolvedId != null) {
      // Cache it for subsequent requests
      await prefs.setString('odoo_employee_id', resolvedId.toString());
      return resolvedId;
    }

    return null;
  }

  Future<void> syncCheckIn({
    required String employeeIdStr,
    required String area,
  }) async {
    final int? employeeId = await _getOrResolveEmployeeId();
    if (employeeId == null) {
      print('Odoo sync skipped: Could not resolve Odoo employee_id');
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
    final int? employeeId = await _getOrResolveEmployeeId();
    if (employeeId == null) {
      print('Odoo sync skipped: Could not resolve Odoo employee_id');
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
