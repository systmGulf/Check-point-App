import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../atoms/supervisor_premission_item.dart';

class SupervisorPermission extends StatefulWidget {
  const SupervisorPermission(
      {super.key,
      required this.supervisorId,
      required this.attendancePermission,
      required this.planPermission});
  final String supervisorId;
  final bool attendancePermission;
  final bool planPermission;

  @override
  State<SupervisorPermission> createState() => _SupervisorPermissionState();
}

class _SupervisorPermissionState extends State<SupervisorPermission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildCustomAppBar(context, "Permission".tr(context: context)),
        body: Column(
          children: [
            SupervisorPermissionItem(
              onChanged: (value) {
                context.read<EmployeeCubit>().attendAntherEmployeePermission(
                    employeeId: widget.supervisorId, permission: value);
                setState(() {});
              },
              isChecked: widget.attendancePermission,
              text: 'Can attend employee'.tr(context: context),
              icon: Icons.verified,
              iconColor: Colors.blue,
            ),
            SupervisorPermissionItem(
              onChanged: (value) {
                context.read<EmployeeCubit>().setPlanPermission(
                    employeeId: widget.supervisorId, permission: value);
                setState(() {});
              },
              isChecked: widget.planPermission,
              text: 'Set Plan and Location'.tr(context: context),
              icon: Icons.location_on,
              iconColor: const Color.fromARGB(255, 207, 171, 168),
            ),
          ],
        ));
  }
}
