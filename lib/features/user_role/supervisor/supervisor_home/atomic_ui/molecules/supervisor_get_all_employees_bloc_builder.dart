import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import 'supervisor_get_employee_in_team_item.dart';

class SupervisorGetAllEmployeesBlocBuilder extends StatelessWidget {
  const SupervisorGetAllEmployeesBlocBuilder({
    super.key,
  });

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
              ? NoInternetConnectionWidget(onPressed: () {
                  context
                      .read<GetEmployeesDataCubit>()
                      .getEmployeesByDepartmentId();
                })
              : Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    verticalSpace(20),
                    Text(state.errorMsg)
                  ],
                );
        } else if (state is GetAllEmployeesSuccess) {
          return state.allEmployeesValue.data!.isEmpty
              ? NoDataFound()
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.allEmployeesValue.data!.length,
                  itemBuilder: (context, index) {
                    return ApiConstant.employeeId !=
                            state.allEmployeesValue.data![index].id
                        ? SupervisorGetEmployeesInTeamItem(
                            name:
                                state.allEmployeesValue.data![index].name ?? '',
                            getAllEmployeesValue:
                                state.allEmployeesValue.data![index],
                            id: state.allEmployeesValue.data![index].id ?? '',
                          )
                        : const SizedBox.shrink();
                  },
                );
        } else {
          return Skeletonizer(
              child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) => SupervisorGetEmployeesInTeamItem(
                name: 'load Data',
                id: 'load Data',
                getAllEmployeesValue: EmployeeData()),
          ));
        }
      },
    );
  }
}
