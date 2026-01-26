import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../atoms/delete_user_bloc_listener.dart';

class UsersListHeader extends StatelessWidget {
  const UsersListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 59.h),
        const DeleteUserBlocListener(),
        Row(
          children: [
            Text(
              'Users List'.tr(context: context),
              style: AppStylesManger.font15BoldBlack,
            ),
            const Spacer(),
            _buildEmployeeCountBadge(context),
          ],
        ),
        verticalSpace(10),
      ],
    );
  }

  Widget _buildEmployeeCountBadge(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorsManger.primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: BlocBuilder<EmployeeCubit, EmployeeState>(
          builder: (context, state) {
            final cubit = context.watch<EmployeeCubit>();
            return Text(
              cubit.totalEmployeesCount?.toString() ?? '0',
              style: AppStylesManger.font14RegularWhite,
            );
          },
        ),
      ),
    );
  }
}
