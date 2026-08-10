import 'package:flutter_test/flutter_test.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/change_password_request_body.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/track_user_request_body.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/employee_check_out_request_body.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_leave_requests_models/leave_request_request_body.dart';

void main() {
  group('Employee request bodies', () {
    test('ChangePasswordRequestBody maps userId and currentPassword keys', () {
      final body = ChangePasswordRequestBody(
        oldPassword: 'old',
        newPassword: 'new',
        employeeId: 'emp-1',
      );

      expect(body.toJson(), {
        'userId': 'emp-1',
        'currentPassword': 'old',
        'newPassword': 'new',
      });
    });

    test('TrackUserRequestBody serializes coordinates payload', () {
      final body = TrackUserRequestBody(
        employeeId: 'emp-1',
        coordinates: [
          {'latitude': 30.0, 'longitude': 31.0},
        ],
      );

      expect(body.toJson(), {
        'employeeId': 'emp-1',
        'coordinates': [
          {'latitude': 30.0, 'longitude': 31.0}
        ],
      });
    });

    test('LeaveRequestRequestBody serializes all request fields', () {
      final body = LeaveRequestRequestBody(
        employeeId: 'emp-1',
        startDate: '2026-07-10',
        endDate: '2026-07-12',
        reason: 'Medical',
        remark: 'Doctor appointment',
        leaveRequestType: 'Annual',
      );

      expect(body.toJson(), {
        'employeeId': 'emp-1',
        'startDate': '2026-07-10',
        'endDate': '2026-07-12',
        'reason': 'Medical',
        'remark': 'Doctor appointment',
        'leaveRequestType': 'Annual',
      });
    });

    test('EmployeeCheckOutRequestBody serializes nullable employee image', () {
      final body = EmployeeCheckOutRequestBody(
        employeeId: 'emp-7',
        employeeImage: null,
      );

      expect(body.toJson(), {
        'employeeId': 'emp-7',
        'employeeImage': null,
      });
    });
  });
}
