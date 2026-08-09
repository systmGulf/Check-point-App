import 'package:flutter_test/flutter_test.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/branches_model/add_branch_request_body.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/customers_model/add_customer_request_body.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/department_model/department_request_body.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/employee_model/add_employee_request_body.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/shifts_and_polices_model/add_shift_request_body.dart';

void main() {
  group('Admin request bodies', () {
    test('AddBrachRequestBody serializes and parses coordinates', () {
      final body = AddBrachRequestBody(
        name: 'Main Branch',
        location: 'Cairo',
        description: 'HQ',
        coordinates: [
          LocationFrameLatLng(latitude: 30.0, longitude: 31.0),
        ],
      );

      final json = body.toJson();
      final parsed = AddBrachRequestBody.fromJson(json);

      expect(json['name'], 'Main Branch');
      expect((json['coordinates'] as List).single['latitude'], 30.0);
      expect(parsed.coordinates.single.longitude, 31.0);
    });

    test('AddOrEditCustomerRequestBody serializes nested coordinates', () {
      final body = AddOrEditCustomerRequestBody(
        name: 'Site A',
        workesAs: 'Guard',
        location: 'Giza',
        coordinates: [
          CustomerLocation(latitude: 29.9, longitude: 31.1),
        ],
        customerType: 'Site',
      );

      final json = body.toJson();

      expect(json, {
        'name': 'Site A',
        'workesAs': 'Guard',
        'location': 'Giza',
        'customerType': 'Site',
        'coordinates': [
          {'latitude': 29.9, 'longitude': 31.1}
        ],
      });
    });

    test('AddEmployeeRequestBody serializes all required fields', () {
      final body = AddEmployeeRequestBody(
        ['device-token'],
        name: 'Osama',
        username: 'osama.user',
        password: 'P@ssw0rd',
        position: 'Supervisor',
        branchId: 1,
        mobileId: 'mobile-1',
        departmentId: 2,
        role: 'supervisor',
      );

      final json = body.toJson();

      expect(json['name'], 'Osama');
      expect(json['username'], 'osama.user');
      expect(json['branchId'], 1);
      expect(json['deviceTokens'], ['device-token']);
    });

    test('DepartmentRequestBody serializes departmentName', () {
      final body = DepartmentRequestBody(departmentName: 'Operations');

      expect(body.toJson(), {
        'departmentName': 'Operations',
      });
    });

    test('AddShiftRequestBody serializes shift name', () {
      final body = AddShiftRequestBody(name: 'Night Shift');

      expect(body.toJson(), {
        'name': 'Night Shift',
      });
    });
  });
}
