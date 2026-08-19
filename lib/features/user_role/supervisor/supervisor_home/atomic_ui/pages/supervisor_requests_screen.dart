import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_leave_requests_repo/employee_action_repo.dart';

import '../../../../../../core/dependency%D9%80injection/register%D9%80factory.dart';
import '../../../../../../core/services/odoo_timeoff_service.dart';
import '../../../../employee/employee_home/atomic_ui/pages/leave_application.dart';
import '../../../../employee/employee_home/controller/leave_application/leave_application_cubit.dart';

/// Requests tab — shows only the supervisor's own leave application screen.
class SupervisorRequestsScreen extends StatelessWidget {
  const SupervisorRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaveApplicationCubit(
        employeeRepo: getIt<EmployeeActionRepo>(),
        odooTimeOffService: getIt<OdooTimeOffService>(),
      ),
      child: const LeaveApplication(),
    );
  }
}
