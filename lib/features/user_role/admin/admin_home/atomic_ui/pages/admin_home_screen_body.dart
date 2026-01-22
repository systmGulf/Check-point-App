import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/animations/animations.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/utils/assets_manager.dart';
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
          Assets.BannerHomeImage,
        ),
        SafeArea(
          child: RefreshIndicator(
            color: ColorsManger.primaryColor,
            onRefresh: () async {
              BlocProvider.of<EmployeeCubit>(
                context,
              ).getAllEmployees(pageNumber: 0, itemCount: 10);
            },
            child: ListView(physics: const BouncingScrollPhysics(), children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: AnimatedHeaderWidget(
                      child: UserNameAndTimeAndCheckInAndOutItem(
                        image: "",
                        name: ApiConstant.username,
                      ),
                    ),
                  ),
                  verticalSpace(5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: AnimatedByWidgetType(
                      widgetType: WidgetAnimationType.container,
                      delayDuration: const Duration(milliseconds: 200),
                      child: const AdminQuickActionsSection(),
                    ),
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
