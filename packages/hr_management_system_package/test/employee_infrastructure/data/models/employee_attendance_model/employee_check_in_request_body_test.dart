import 'package:flutter_test/flutter_test.dart';
import 'package:hr_management_system_package/attendance.dart';

void main() {
  test('EmployeeCheckInRequestBody serializes expected backend keys', () {
    final body = EmployeeCheckInRequestBody(
      'customer-9',
      'image-url',
      employeeIdd: 'employee-1',
      area: 'Customer',
      location: '30.0,31.0',
    );

    expect(body.toJson(), {
      'employeeId': 'employee-1',
      'area': 'Customer',
      'customerId': 'customer-9',
      'location': '30.0,31.0',
      'employeeImage': 'image-url',
    });
  });
}
