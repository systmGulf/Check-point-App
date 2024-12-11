import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../molecules/members_in_department_list_view.dart';

class GetMembersByDepartment extends StatelessWidget {
  const GetMembersByDepartment(
      {super.key, required this.role, required this.departmentId});
  final int departmentId;
  final String role;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, EmployeeState>(
        buildWhen: (state, currentState) =>
            currentState is GetEmployeeByDepartmentSuccess ||
            currentState is GetEmployeeByDepartmentLoading ||
            currentState is GetEmployeeByDepartmentError,
        builder: (context, state) {
          if (state is GetEmployeeByDepartmentSuccess) {
            var manger = state.employeeList.data!
                .where((element) => element.role == role)
                .toList();
            return MembersInDepartmentListView(
                manger: manger, role: role, departmentId: departmentId);
          } else if (state is GetEmployeeByDepartmentLoading) {
            return ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return const Center(child: CircularProgressIndicator());
                });
          } else if (state is GetEmployeeByDepartmentError) {
            return Text(state.toString());
          } else {
            return const SizedBox();
          }
        });
  }
}
