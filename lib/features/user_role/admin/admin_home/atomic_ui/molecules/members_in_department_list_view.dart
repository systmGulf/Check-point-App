import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/admin/data/models/department_model/get_employees_in_department.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../pages/supervisor_premission_screen.dart';

class MembersInDepartmentListView extends StatelessWidget {
  const MembersInDepartmentListView({
    super.key,
    required this.manger,
    required this.role,
    required this.departmentId,
  });

  final List<GetEmployeesInDepartmentData> manger;
  final String role;
  final int departmentId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: manger.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                if (role == 'Supervisor') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                                create: (context) => getIt<EmployeeCubit>(),
                                child: SupervisorPermission(
                                  planPermission:
                                      manger[index].canAddPlan ?? false,
                                  attendancePermission:
                                      manger[index].canAddAttendance ?? false,
                                  supervisorId: manger[index].id ?? '',
                                ),
                              ))).then((value) {
                    if (!context.mounted) return;
                    context
                        .read<EmployeeCubit>()
                        .getEmployeeByDepartment(departmentId: departmentId);
                  });
                }
              },
              contentPadding: const EdgeInsets.all(0),
              leading: CircleAvatar(
                backgroundColor: ColorsManger.primaryColor,
                radius: 25,
                backgroundImage: const AssetImage(
                  'assets/images/icon-default-user.png',
                ),
              ),
              title: Text(
                manger[index].name ?? '',
                style: AppStylesManger.font16BoldBlack.copyWith(
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                manger[index].position ?? '',
                style: AppStylesManger.font15regulerGrey.copyWith(fontSize: 12),
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        });
  }
}
