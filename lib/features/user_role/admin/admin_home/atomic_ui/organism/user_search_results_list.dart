import 'package:employee_mangement/features/user_role/admin/admin_home/atomic_ui/enitities/user_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/styles/colors.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../pages/edit_user_screen.dart';

class UserSearchResultsList extends StatelessWidget {
  final VoidCallback onNavigateBack;

  const UserSearchResultsList({
    super.key,
    required this.onNavigateBack,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, EmployeeState>(
      builder: (context, state) {
        if (state is SearchEmployeeSuccess) {
          return _buildSearchResults(context, state.employeeList.data!);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSearchResults(
      BuildContext context, List<EmployeeData> employees) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        color: Colors.white,
        elevation: 4.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: employees
              .map((employee) => _buildSearchResultItem(context, employee))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(BuildContext context, EmployeeData employee) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(Icons.person, color: ColorsManger.primaryColor),
        trailing: Icon(Icons.chevron_right, color: ColorsManger.primaryColor),
        title: Text(employee.name ?? ''),
        onTap: () => _navigateToEditUser(context, employee),
      ),
    );
  }

  void _navigateToEditUser(BuildContext context, EmployeeData employee) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => getIt<EmployeeCubit>(),
              child: EditUser(
                userItemEntity: UserItemEntity(
                  branchId: employee.branchId ?? 0,
                  branch: employee.branchName ?? "",
                  departmentId: employee.departmentId ?? 0,
                  mobileId: employee.mobileId ?? "",
                  role: employee.role ?? "",
                  userId: employee.id ?? "",
                  name: employee.name ?? "",
                  userName: employee.userName ?? "",
                  position: employee.position ?? "",
                  department: employee.departmentName ?? "",
                  shiftName: employee.shiftName ?? "",
                  shiftStartTime: employee.clockInTime ?? "",
                  shiftEndTime: employee.clockOutTime ?? "",
                  imageUrl: employee.imageUrl ?? "",
                  onDelete: () {},
                ),
              ),
            ),
          ),
        )
        .then((_) => onNavigateBack());
  }
}
