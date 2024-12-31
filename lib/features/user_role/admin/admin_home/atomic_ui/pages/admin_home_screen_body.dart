import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/user_name_and_time_and_check_in_and_out.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../molecules/users_list.dart';
import '../organism/admin_quick_action_section.dart';

class AdminHomeScreenBody extends StatelessWidget {
  const AdminHomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          'assets/images/banner-home.png',
        ),
        SafeArea(
          child: RefreshIndicator(
            color: ColorsManger.primaryColor,
            onRefresh: () async {
              BlocProvider.of<EmployeeCubit>(
                context,
              ).getAllEmployees();
            },
            child: ListView(physics: const BouncingScrollPhysics(), children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: UserNameAndTimeAndCheckInAndOutItem(
                      name: ApiConstant.username,
                    ),
                  ),
                  verticalSpace(5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        child: AdminQuickActionsSection()),
                  ),
                  verticalSpace(5),
                  const UsersList(),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
