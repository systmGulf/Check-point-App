import 'package:flutter_test/flutter_test.dart';
import 'package:hr_management_system_package/admin.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/user_attendace_model.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_leave_requests_models/employee_leave_requests.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_summary_model/employee_summary_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employees_attendance_model/get_employee_attendance.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/get_plan_by_id_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/get_plan_model.dart';

void main() {
  group('Response envelope models', () {
    test('AllEmployeesModel parses the full response envelope', () {
      final response = AllEmployeesModel.fromJson({
        'value': {
          'data': [
            {'id': 'emp-1', 'name': 'Osama'}
          ],
          'totalCount': 1,
          'pageCount': 1,
          'hasNextPage': false,
          'hasPreviousPage': false,
          'start': 0,
          'end': 1,
        },
        'status': 200,
        'isSuccess': true,
        'successMessage': 'ok',
        'correlationId': 'corr-1',
        'errors': <dynamic>[],
        'validationErrors': <dynamic>[],
      });

      expect(response.employeesPageOrEmpty.totalCount, 1);
      expect(response.employeesPageOrEmpty.data?.first.id, 'emp-1');
      expect(response.employeesPageOrEmpty.data?.first.name, 'Osama');
    });

    test('GetEmployeesInDepartmentModel parses the full response envelope', () {
      final response = GetEmployeesInDepartmentModel.fromJson({
        'value': {
          'data': [
            {'id': 'emp-2', 'name': 'Ali'}
          ],
          'totalCount': 1,
          'pageCount': 1,
          'hasNextPage': false,
          'hasPreviousPage': false,
          'start': 0,
          'end': 1,
        },
        'status': 200,
        'isSuccess': true,
      });

      expect(response.employeesPageOrEmpty.data?.first.id, 'emp-2');
      expect(response.employeesPageOrEmpty.data?.first.name, 'Ali');
    });

    test('DepartmentModel parses departments through the response envelope', () {
      final response = DepartmentModel.fromJson({
        'value': {
          'data': [
            {'id': 7, 'departmentName': 'Sales'}
          ],
          'totalCount': 1,
          'pageCount': 1,
          'hasNextPage': false,
          'hasPreviousPage': false,
          'start': 0,
          'end': 1,
        },
        'status': 200,
        'isSuccess': true,
      });

      expect(response.departmentsPageOrEmpty.data?.first.id, 7);
      expect(
        response.departmentsPageOrEmpty.data?.first.departmentName,
        'Sales',
      );
    });

    test('CustomerModel parses customers through the response envelope', () {
      final response = CustomerModel.fromJson({
        'value': {
          'data': [
            {'id': 'cust-1', 'name': 'Main Site'}
          ],
          'totalCount': 1,
          'pageCount': 1,
          'hasNextPage': false,
          'hasPreviousPage': false,
          'start': 0,
          'end': 1,
        },
        'status': 200,
        'isSuccess': true,
      });

      expect(response.customersPageOrEmpty.data?.first.id, 'cust-1');
      expect(response.customersPageOrEmpty.data?.first.name, 'Main Site');
    });

    test('GetBranchesModel parses branches through the response envelope', () {
      final response = GetBranchesModel.fromJson({
        'value': {
          'data': [
            {'id': 10, 'name': 'HQ'}
          ],
          'totalCount': 1,
          'pageCount': 1,
          'hasNextPage': false,
          'hasPreviousPage': false,
          'start': 0,
          'end': 1,
        },
        'status': 200,
        'isSuccess': true,
      });

      expect(response.branchesPageOrEmpty.data?.first.id, 10);
      expect(response.branchesPageOrEmpty.data?.first.name, 'HQ');
    });

    test('EmployeeLeaveRequestsModel parses leave requests through the response envelope', () {
      final response = EmployeeLeaveRequestsModel.fromJson({
        'value': {
          'data': [
            {'id': 14, 'reason': 'Vacation'}
          ],
          'totalCount': 1,
          'pageCount': 1,
          'hasNextPage': false,
          'hasPreviousPage': false,
          'start': 0,
          'end': 1,
        },
        'status': 200,
        'isSuccess': true,
      });

      expect(response.leaveRequestsPageOrEmpty.data?.first.id, 14);
      expect(response.leaveRequestsPageOrEmpty.data?.first.reason, 'Vacation');
    });

    test('UserAttendanceModel parses attendance history through the response envelope', () {
      final response = UserAttendanceModel.fromJson({
        'value': {
          'data': [
            {'id': 22, 'employeeName': 'Nada'}
          ],
          'totalCount': 1,
          'pageCount': 1,
          'hasNextPage': false,
          'hasPreviousPage': false,
          'start': 0,
          'end': 1,
        },
        'status': 200,
        'isSuccess': true,
      });

      expect(response.attendancePageOrEmpty.data?.first.id, 22);
      expect(response.attendancePageOrEmpty.data?.first.employeeName, 'Nada');
    });

    test('Supervisor attendance envelope exposes the typed attendance page', () {
      final response = SupervisorGetAllEmployeesAttendanceModel.fromJson({
        'value': {
          'data': [
            {'id': 30, 'employeeName': 'Mona'}
          ],
          'totalCount': 1,
          'pageCount': 1,
          'hasNextPage': false,
          'hasPreviousPage': false,
          'start': 0,
          'end': 1,
        },
        'status': 200,
        'isSuccess': true,
      });

      expect(response.attendancePageOrEmpty.data?.first.id, 30);
      expect(response.attendancePageOrEmpty.data?.first.employeeName, 'Mona');
    });

    test('PlanModel parses plan pages through the response envelope', () {
      final response = PlanModel.fromJson({
        'value': {
          'data': [
            {'id': 40, 'planDate': '2026-07-07'}
          ],
          'totalCount': 1,
          'pageCount': 1,
          'hasNextPage': false,
          'hasPreviousPage': false,
          'start': 0,
          'end': 1,
        },
        'status': 200,
        'isSuccess': true,
      });

      expect(response.plansPageOrEmpty.data?.first.id, 40);
      expect(response.plansPageOrEmpty.data?.first.planDate, '2026-07-07');
    });

    test('GetPlanById exposes plan details from the full response envelope', () {
      final response = GetPlanById.fromJson({
        'value': {
          'id': 88,
          'planDate': '2026-07-07',
          'note': 'visit customer',
          'customerPlans': <dynamic>[],
        },
        'status': 200,
        'isSuccess': true,
      });

      expect(response.planDetailsOrEmpty.id, 88);
      expect(response.planDetailsOrEmpty.note, 'visit customer');
    });

    test('EmployeeSummary exposes the typed summary payload', () {
      final response = EmployeeSummary.fromJson({
        'value': {
          'employeeId': 'emp-3',
          'employeeName': 'Huda',
          'totalDaysWorked': 12,
        },
        'status': 200,
        'isSuccess': true,
      });

      expect(response.summaryOrEmpty.employeeId, 'emp-3');
      expect(response.summaryOrEmpty.totalDaysWorked, 12);
    });
  });
}
