import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/contoller/roles_login_cubit/login_cubit.dart';
import '../../../../../../core/widgets/user_name_and_time_and_check_in_and_out.dart';

class GetEmployeeDataInEmployeeHomeScreenBlocBuilder extends StatelessWidget {
  const GetEmployeeDataInEmployeeHomeScreenBlocBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return UserNameAndTimeAndCheckInAndOutItem(
      image: '',
      name: "${ApiConstant.username}",
    );
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) =>
            current is GetEmployeeLoading ||
            current is GetEmployeeSuccess ||
            current is GetEmployeeFailure,
        builder: (context, state) {
          if (state is GetEmployeeSuccess) {
            return Column(
              children: [
                UserNameAndTimeAndCheckInAndOutItem(
                  image: state.employeeLoginModel.imageUrl ?? '',
                  name: "${state.employeeLoginModel.name}",
                ),
              ],
            );
          } else if (state is GetEmployeeFailure) {
            return Text(state.error);
          } else {
            return Skeletonizer(
                child: const UserNameAndTimeAndCheckInAndOutItem(
              image: '',
              name: "Data Loading",
            ));
          }
        });
  }
}
