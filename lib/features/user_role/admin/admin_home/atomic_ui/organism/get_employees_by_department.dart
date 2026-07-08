import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/department_model/get_employees_in_department.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../pages/supervisor_premission_screen.dart';
import './employees_by_department_loading_skeleton.dart';

class GetMembersByDepartment extends StatelessWidget {
  const GetMembersByDepartment({
    super.key,
    required this.role,
    required this.departmentId,
  });

  final int departmentId;
  final String role;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, EmployeeState>(
      builder: (context, state) {
        if (state is GetEmployeeByDepartmentLoading) {
          return const EmployeesByDepartmentLoadingSkeleton();
        }
        if (state is GetEmployeeByDepartmentError) {
          return NoInternetConnectionWidget(
            onPressed: () => context
                .read<EmployeeCubit>()
                .getEmployeeByDepartment(departmentId: departmentId),
          );
        }
        if (state is GetEmployeeByDepartmentSuccess) {
          final filtered =
              state.employeeList.data?.where((e) => e.role == role).toList() ??
                  [];
          if (filtered.isEmpty) {
            return const Center(child: Text('No members found'));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            itemBuilder: (context, index) =>
                _buildEmployeeItem(context, filtered[index]),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmployeeItem(
      BuildContext context, GetEmployeesInDepartmentData employee) {
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
                    planPermission: employee.canAddPlan ?? false,
                    attendancePermission: employee.canAddAttendance ?? false,
                    supervisorId: employee.id ?? '',
                  ),
                ),
              ),
            ).then((_) {
              if (!context.mounted) return;
              context
                  .read<EmployeeCubit>()
                  .getEmployeeByDepartment(departmentId: departmentId);
            });
          }
        },
        contentPadding: const EdgeInsets.all(0),
        leading: UserImage(imageUrl: employee.imageUrl ?? '', height: 50),
        title: Text(
          employee.userName ?? employee.name ?? '',
          style: AppStylesManger.font16BoldBlack.copyWith(fontSize: 14),
        ),
        subtitle: Text(
          employee.position ?? '',
          style: AppStylesManger.font15regulerGrey.copyWith(fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
