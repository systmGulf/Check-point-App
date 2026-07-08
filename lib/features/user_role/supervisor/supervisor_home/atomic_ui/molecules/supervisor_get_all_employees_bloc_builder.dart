import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:employee_mangement/core/widgets/no_interet_connextion_widget.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/molecules/supervisor_get_employee_in_team_item.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../molecules/supervisor_get_all_employees_loading_skeleton.dart';

class SupervisorGetAllEmployeesBlocBuilder extends StatelessWidget {
  final String? query;
  const SupervisorGetAllEmployeesBlocBuilder({super.key, this.query});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetEmployeesDataCubit, GetEmployeesDataState>(
      buildWhen: (previous, current) =>
          current is GetAllEmployeesSuccess ||
          current is GetAllEmployeesFailure ||
          current is GetAllEmployeesLoading,
      builder: (context, state) {
        if (state is GetAllEmployeesFailure) {
          return state.errorMsg == 'Please check your internet connection'
              ? NoInternetConnectionWidget(
                  onPressed: () {
                    context
                        .read<GetEmployeesDataCubit>()
                        .getEmployeesByDepartmentId();
                  },
                )
              : Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    verticalSpace(20),
                    Text(state.errorMsg),
                  ],
                );
        } else if (state is GetAllEmployeesSuccess) {
          final filterList = state.allEmployeesValue.data!
              .where(
                (element) => (element.userName ?? element.name ?? '')
                    .toLowerCase()
                    .contains(
                      query?.toLowerCase() ?? "",
                    ),
              )
              .toList();
          final employeeList =
              filterList.isEmpty ? state.allEmployeesValue.data! : filterList;
          return state.allEmployeesValue.data!.isEmpty
              ? NoDataFound()
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: employeeList.length,
                  itemBuilder: (context, index) {
                    return ApiConstant.employeeId != employeeList[index].id
                        ? SupervisorGetEmployeesInTeamItem(
                            name: employeeList[index].userName ??
                                employeeList[index].name ??
                                '',
                            getAllEmployeesValue: employeeList[index],
                            id: employeeList[index].id ?? '',
                          )
                        : const SizedBox.shrink();
                  },
                );
        } else {
          return const SupervisorGetAllEmployeesLoadingSkeleton();
        }
      },
    );
  }
}
