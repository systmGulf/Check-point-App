import 'package:flutter_test/flutter_test.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employees_attendance_model/supervisor_employee_check_out_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_summary_model/employee_attendance_summary_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/remove_employees_from_plan_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/set_customer_plan_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/task_model/add_task_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/task_model/assign_task_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/task_model/remove_assign_task_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/task_model/update_task_status_request_body.dart';

void main() {
  group('Supervisor request bodies', () {
    test('AddTaskRequestBody serializes task fields', () {
      final body = AddTaskRequestBody(
        title: 'Visit Site',
        description: 'Morning shift follow-up',
        dueDate: '2026-07-08',
        priorityStatus: 'High',
        status: 'Pending',
      );

      expect(body.toJson(), {
        'title': 'Visit Site',
        'description': 'Morning shift follow-up',
        'dueDate': '2026-07-08',
        'priorityStatus': 'High',
        'status': 'Pending',
      });
    });

    test('SetCustomerPlanRequestBody serializes nested plan fields', () {
      final body = SetCustomerPlanRequestBody(
        planDate: '2026-07-08',
        note: 'Main route',
        employeeIds: ['1', '2'],
        customerId: 'customer-1',
      );

      expect(body.toJson(), {
        'planDate': '2026-07-08',
        'note': 'Main route',
        'employeeIds': ['1', '2'],
        'customerId': 'customer-1',
      });
    });

    test('SetPlanByDateRequestBody serializes department plan', () {
      final body = SetPlanByDateRequestBody(
        planDate: '2026-07-08',
        note: 'Dept plan',
        departmentId: 'dept-2',
      );

      expect(body.toJson(), {
        'planDate': '2026-07-08',
        'note': 'Dept plan',
        'departmentId': 'dept-2',
      });
    });

    test('SetSubPlansRequestBody uses customerId json key', () {
      final body = SetSubPlansRequestBody(
        note: 'Sub route',
        employeeIds: ['5'],
        customerIdOrSiteId: 'site-8',
        planId: 99,
      );

      expect(body.toJson(), {
        'note': 'Sub route',
        'employeeIds': ['5'],
        'customerId': 'site-8',
        'planId': 99,
      });
    });

    test('AssignTaskRequestBody serializes task assignment', () {
      final body = AssignTaskRequestBody(
        employeeIds: ['1', '2'],
        taskId: 77,
      );

      expect(body.toJson(), {
        'employeeIds': ['1', '2'],
        'taskId': 77,
      });
    });

    test('UpdateTaskStatusRequestBody serializes task status change', () {
      final body = UpdateTaskStatusRequestBody(
        id: 31,
        status: 'Completed',
      );

      expect(body.toJson(), {
        'id': 31,
        'status': 'Completed',
      });
    });

    test('RemoveAssignTaskRequestBody serializes employee-task unlink', () {
      final body = RemoveAssignTaskRequestBody(
        employeeId: 'emp-5',
        taskId: 18,
      );

      expect(body.toJson(), {
        'employeeId': 'emp-5',
        'taskId': 18,
      });
    });

    test('RemoveEmployeesFromPlanRequestBody serializes plan unlink payload', () {
      final body = RemoveEmployeesFromPlanRequestBody(
        employeeIds: 'emp-1,emp-2',
        customerPlanId: 88,
      );

      expect(body.toJson(), {
        'employeeIds': 'emp-1,emp-2',
        'customerPlanId': 88,
      });
    });

    test('SupervisorEmployeeCheckOutRequestBody serializes nullable image', () {
      final body = SupervisorEmployeeCheckOutRequestBody(
        employeeId: 'emp-9',
        employeeImage: 'base64-image',
      );

      expect(body.toJson(), {
        'employeeId': 'emp-9',
        'employeeImage': 'base64-image',
      });
    });

    test('EmployeeAttendanceSummaryRequestBody serializes summary filters', () {
      final body = EmployeeAttendanceSummaryRequestBody(
        employeeId: 'emp-3',
        month: 7,
        year: 2026,
      );

      expect(body.toJson(), {
        'employeeId': 'emp-3',
        'month': 7,
        'year': 2026,
      });
    });
  });
}
