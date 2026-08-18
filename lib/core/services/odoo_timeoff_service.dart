import 'package:dio/dio.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

class OdooLeaveType {
  final int id;
  final String name;
  final bool requiresAllocation;

  OdooLeaveType({
    required this.id,
    required this.name,
    required this.requiresAllocation,
  });

  factory OdooLeaveType.fromJson(Map<String, dynamic> json) {
    return OdooLeaveType(
      id: json['id'] as int,
      name: json['name'] as String,
      requiresAllocation: json['requires_allocation'] == 'yes' || json['requires_allocation'] == true,
    );
  }
}

class OdooPublicHoliday {
  final int id;
  final String name;
  final String dateFrom;
  final String dateTo;

  OdooPublicHoliday({
    required this.id,
    required this.name,
    required this.dateFrom,
    required this.dateTo,
  });

  factory OdooPublicHoliday.fromJson(Map<String, dynamic> json) {
    return OdooPublicHoliday(
      id: json['id'] as int,
      name: json['name'] as String,
      dateFrom: json['date_from'] as String,
      dateTo: json['date_to'] as String,
    );
  }
}

class OdooAttendanceLog {
  final int id;
  final String employeeId;
  final String employeeName;
  final String location;
  final String checkIn;
  final String? checkOut;
  final double workedHours;

  OdooAttendanceLog({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.location,
    required this.checkIn,
    this.checkOut,
    required this.workedHours,
  });

  factory OdooAttendanceLog.fromJson(Map<String, dynamic> json) {
    return OdooAttendanceLog(
      id: json['id'] as int,
      employeeId: json['employee_id'] as String? ?? '',
      employeeName: json['employee_name'] as String? ?? '',
      location: json['location'] as String? ?? 'site',
      checkIn: json['check_in'] as String,
      checkOut: json['check_out'] as String?,
      workedHours: (json['worked_hours'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class OdooMyAttendanceData {
  final String employeeId;
  final String employeeName;
  final String period;
  final String dateFrom;
  final String dateTo;
  final int count;
  final double totalWorkedHours;
  final List<OdooAttendanceLog> attendances;

  OdooMyAttendanceData({
    required this.employeeId,
    required this.employeeName,
    required this.period,
    required this.dateFrom,
    required this.dateTo,
    required this.count,
    required this.totalWorkedHours,
    required this.attendances,
  });

  factory OdooMyAttendanceData.fromJson(Map<String, dynamic> json) {
    final list = json['attendances'] as List? ?? [];
    return OdooMyAttendanceData(
      employeeId: json['employee_id'] as String? ?? '',
      employeeName: json['employee_name'] as String? ?? '',
      period: json['period'] as String? ?? 'month',
      dateFrom: json['date_from'] as String? ?? '',
      dateTo: json['date_to'] as String? ?? '',
      count: json['count'] as int? ?? 0,
      totalWorkedHours: (json['total_worked_hours'] as num?)?.toDouble() ?? 0.0,
      attendances: list.map((e) => OdooAttendanceLog.fromJson(e)).toList(),
    );
  }
}

class OdooLeaveRequest {
  final int id;
  final String employeeId;
  final String employeeName;
  final int leaveTypeId;
  final String leaveTypeName;
  final String dateFrom;
  final String dateTo;
  final double numberOfDays;
  final String reason;
  final String state;

  OdooLeaveRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.leaveTypeId,
    required this.leaveTypeName,
    required this.dateFrom,
    required this.dateTo,
    required this.numberOfDays,
    required this.reason,
    required this.state,
  });

  factory OdooLeaveRequest.fromJson(Map<String, dynamic> json) {
    return OdooLeaveRequest(
      id: json['id'] as int,
      employeeId: (json['employee_id'] ?? json['mobile_employee_id'] ?? '') as String,
      employeeName: json['employee_name'] as String? ?? '',
      leaveTypeId: json['leave_type_id'] as int,
      leaveTypeName: json['leave_type_name'] as String? ?? '',
      dateFrom: json['date_from'] as String,
      dateTo: json['date_to'] as String,
      numberOfDays: (json['number_of_days'] as num?)?.toDouble() ?? 0.0,
      reason: json['reason'] as String? ?? '',
      state: json['state'] as String? ?? '',
    );
  }
}

class OdooTimeOffService {
  final Dio _dio;

  OdooTimeOffService()
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

  Future<List<OdooLeaveType>> getLeaveTypes() async {
    print('--- ODOO TIME OFF GET LEAVE TYPES REQUEST ---');
    print('Url: ${_dio.options.baseUrl}/api/timeoff/types');
    print('Headers: ${_dio.options.headers}');
    try {
      final response = await _dio.get('/api/timeoff/types');
      print('--- ODOO TIME OFF GET LEAVE TYPES SUCCESS RESPONSE ---');
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      if (response.data != null && response.data['success'] == true) {
        final list = response.data['data']['leave_types'] as List;
        return list.map((e) => OdooLeaveType.fromJson(e)).toList();
      }
      throw Exception(_mapError(response.data));
    } on DioException catch (e) {
      print('--- ODOO TIME OFF GET LEAVE TYPES DIO ERROR ---');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      throw Exception(_mapDioError(e));
    } catch (e) {
      print('--- ODOO TIME OFF GET LEAVE TYPES GENERAL ERROR ---');
      print('Error: $e');
      rethrow;
    }
  }

  Future<List<OdooPublicHoliday>> getPublicHolidays({String? dateFrom, String? dateTo}) async {
    final Map<String, dynamic> queryParams = {};
    if (dateFrom != null) queryParams['date_from'] = dateFrom;
    if (dateTo != null) queryParams['date_to'] = dateTo;

    print('--- ODOO TIME OFF GET PUBLIC HOLIDAYS REQUEST ---');
    print('Url: ${_dio.options.baseUrl}/api/timeoff/public_holidays');
    print('Query Params: $queryParams');
    print('Headers: ${_dio.options.headers}');
    try {
      final response = await _dio.get('/api/timeoff/public_holidays', queryParameters: queryParams);
      print('--- ODOO TIME OFF GET PUBLIC HOLIDAYS SUCCESS RESPONSE ---');
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      if (response.data != null && response.data['success'] == true) {
        final list = response.data['data']['public_holidays'] as List;
        return list.map((e) => OdooPublicHoliday.fromJson(e)).toList();
      }
      throw Exception(_mapError(response.data));
    } on DioException catch (e) {
      print('--- ODOO TIME OFF GET PUBLIC HOLIDAYS DIO ERROR ---');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      throw Exception(_mapDioError(e));
    } catch (e) {
      print('--- ODOO TIME OFF GET PUBLIC HOLIDAYS GENERAL ERROR ---');
      print('Error: $e');
      rethrow;
    }
  }

  Future<OdooLeaveRequest> submitLeaveRequest({
    required String employee_id,
    required int leaveTypeId,
    required String dateFrom,
    required String dateTo,
    String? reason,
  }) async {
    final Map<String, dynamic> requestBody = {
      'mobile_employee_id': employee_id,
      'leave_type_id': leaveTypeId,
      'date_from': dateFrom,
      'date_to': dateTo,
      if (reason != null && reason.isNotEmpty) 'reason': reason,
    };

    print('--- ODOO TIME OFF SUBMIT LEAVE REQUEST ---');
    print('Url: ${_dio.options.baseUrl}/api/timeoff/request');
    print('Body: $requestBody');
    print('Headers: ${_dio.options.headers}');
    try {
      final response = await _dio.post(
        '/api/timeoff/request',
        data: requestBody,
      );
      print('--- ODOO TIME OFF SUBMIT LEAVE REQUEST SUCCESS RESPONSE ---');
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      if (response.data != null && response.data['success'] == true) {
        return OdooLeaveRequest.fromJson(response.data['data']);
      }
      throw Exception(_mapError(response.data));
    } on DioException catch (e) {
      print('--- ODOO TIME OFF SUBMIT LEAVE REQUEST DIO ERROR ---');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      throw Exception(_mapDioError(e));
    } catch (e) {
      print('--- ODOO TIME OFF SUBMIT LEAVE REQUEST GENERAL ERROR ---');
      print('Error: $e');
      rethrow;
    }
  }

  Future<List<OdooLeaveRequest>> getMyLeaveRequests({
    required String employee_id,
    String? state,
    int limit = 20,
  }) async {
    final Map<String, dynamic> queryParams = {
      'mobile_employee_id': employee_id,
      'limit': limit,
    };
    if (state != null && state.isNotEmpty) {
      queryParams['state'] = state;
    }

    print('--- ODOO TIME OFF GET MY LEAVE REQUESTS ---');
    print('Url: ${_dio.options.baseUrl}/api/timeoff/my_requests');
    print('Query Params: $queryParams');
    print('Headers: ${_dio.options.headers}');
    try {
      final response = await _dio.get('/api/timeoff/my_requests', queryParameters: queryParams);
      print('--- ODOO TIME OFF GET MY LEAVE REQUESTS SUCCESS RESPONSE ---');
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      if (response.data != null && response.data['success'] == true) {
        final list = response.data['data']['requests'] as List;
        return list.map((e) => OdooLeaveRequest.fromJson(e)).toList();
      }
      throw Exception(_mapError(response.data));
    } on DioException catch (e) {
      print('--- ODOO TIME OFF GET MY LEAVE REQUESTS DIO ERROR ---');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      throw Exception(_mapDioError(e));
    } catch (e) {
      print('--- ODOO TIME OFF GET MY LEAVE REQUESTS GENERAL ERROR ---');
      print('Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAttendanceStatus({required String employee_id}) async {
    final Map<String, dynamic> queryParams = {
      'employee_id': employee_id,
    };
    print('--- ODOO ATTENDANCE GET CURRENT STATUS ---');
    print('Url: ${_dio.options.baseUrl}/api/attendance/status');
    print('Query Params: $queryParams');
    try {
      final response = await _dio.get('/api/attendance/status', queryParameters: queryParams);
      print('--- ODOO ATTENDANCE GET CURRENT STATUS SUCCESS ---');
      print('Response Data: ${response.data}');
      if (response.data != null && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
      throw Exception(_mapError(response.data));
    } on DioException catch (e) {
      print('--- ODOO ATTENDANCE GET CURRENT STATUS DIO ERROR ---');
      throw Exception(_mapDioError(e));
    } catch (e) {
      print('--- ODOO ATTENDANCE GET CURRENT STATUS GENERAL ERROR ---');
      rethrow;
    }
  }

  Future<OdooMyAttendanceData> getMyAttendance({
    required String employee_id,
    required String period,
    String? year,
    String? month,
    String? week,
    String? dateFrom,
    String? dateTo,
  }) async {
    final Map<String, dynamic> queryParams = {
      'employee_id': employee_id,
      'period': period,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (week != null) 'week': week,
      if (dateFrom != null) 'date_from': dateFrom,
      if (dateTo != null) 'date_to': dateTo,
    };
    print('--- ODOO ATTENDANCE GET MY ATTENDANCE ---');
    print('Url: ${_dio.options.baseUrl}/api/attendance/my_attendance');
    print('Query Params: $queryParams');
    try {
      final response = await _dio.get('/api/attendance/my_attendance', queryParameters: queryParams);
      print('--- ODOO ATTENDANCE GET MY ATTENDANCE SUCCESS ---');
      print('Response Data: ${response.data}');
      if (response.data != null && response.data['success'] == true) {
        return OdooMyAttendanceData.fromJson(response.data['data']);
      }
      throw Exception(_mapError(response.data));
    } on DioException catch (e) {
      print('--- ODOO ATTENDANCE GET MY ATTENDANCE DIO ERROR ---');
      throw Exception(_mapDioError(e));
    } catch (e) {
      print('--- ODOO ATTENDANCE GET MY ATTENDANCE GENERAL ERROR ---');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAllAttendance({
    String? employee_id,
    String? location,
    String? dateFrom,
    String? dateTo,
    int limit = 50,
    int offset = 0,
  }) async {
    final Map<String, dynamic> queryParams = {
      if (employee_id != null && employee_id.isNotEmpty) 'employee_id': employee_id,
      if (location != null && location.isNotEmpty) 'location': location,
      if (dateFrom != null && dateFrom.isNotEmpty) 'date_from': dateFrom,
      if (dateTo != null && dateTo.isNotEmpty) 'date_to': dateTo,
      'limit': limit,
      'offset': offset,
    };
    print('--- ODOO ATTENDANCE GET ALL ATTENDANCE ---');
    print('Url: ${_dio.options.baseUrl}/api/attendance/all');
    print('Query Params: $queryParams');
    try {
      final response = await _dio.get('/api/attendance/all', queryParameters: queryParams);
      print('--- ODOO ATTENDANCE GET ALL ATTENDANCE SUCCESS ---');
      print('Response Data: ${response.data}');
      if (response.data != null && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
      throw Exception(_mapError(response.data));
    } on DioException catch (e) {
      print('--- ODOO ATTENDANCE GET ALL ATTENDANCE DIO ERROR ---');
      throw Exception(_mapDioError(e));
    } catch (e) {
      print('--- ODOO ATTENDANCE GET ALL ATTENDANCE GENERAL ERROR ---');
      rethrow;
    }
  }

  String _mapError(dynamic responseData) {
    if (responseData != null && responseData['error'] != null) {
      final err = responseData['error'];
      final code = err['code'];
      final message = err['message'] ?? '';
      switch (code) {
        case 'no_api_key':
          return 'Authentication API key is missing';
        case 'invalid_api_key':
          return 'Authentication API key is invalid';
        case 'missing_employee_id':
          return 'Employee ID is required';
        case 'employee_not_found':
          return 'Employee record not found in Odoo';
        case 'leave_type_not_found':
          return 'Selected leave type not found';
        case 'missing_leave_type_id':
          return 'Leave type is required';
        case 'missing_date_range':
          return 'Start date and end date are required';
        case 'invalid_date':
          return 'Invalid date format (must be YYYY-MM-DD)';
        case 'invalid_date_range':
          return 'End date cannot be before start date';
        default:
          return message.isNotEmpty ? message : 'An error occurred';
      }
    }
    return 'Failed request';
  }

  String _mapDioError(DioException error) {
    if (error.response?.data != null) {
      return _mapError(error.response?.data);
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your network and try again.';
      case DioExceptionType.connectionError:
        return 'Connection failed. Please check your internet.';
      default:
        return 'Network error: ${error.message}';
    }
  }
}
