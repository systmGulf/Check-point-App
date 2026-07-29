import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../../../../../core/helpers/extention.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../atoms/delete_user_bloc_listener.dart';

class UsersListHeader extends StatelessWidget {
  const UsersListHeader({
    super.key,
    this.isSelectionMode = false,
    this.onSelectionModeToggled,
  });

  final bool isSelectionMode;
  final VoidCallback? onSelectionModeToggled;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCubit, EmployeeState>(
      listenWhen: (previous, current) =>
          current is ExportEmployeesLoading ||
          current is ExportEmployeesSuccess ||
          current is ExportEmployeesFailure,
      listener: (context, state) {
        if (state is ExportEmployeesLoading) {
          customLoadingIndicator(context);
        } else if (state is ExportEmployeesSuccess) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Export success'.tr(),
            ),
          );
        } else if (state is ExportEmployeesFailure) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error.tr(),
            ),
          );
        }
      },
      child: Column(
        children: [
          SizedBox(height: 59.h),
          const DeleteUserBlocListener(),
          Row(
            children: [
              Text(
                'Users List'.tr(),
                style: AppStylesManger.font15BoldBlack,
              ),
              const Spacer(),
              _buildEmployeeCountBadge(context),
              horizontalSpace(8),
              if (onSelectionModeToggled != null) ...[
                IconButton(
                  onPressed: onSelectionModeToggled,
                  icon: Icon(
                    isSelectionMode ? Icons.check_box : Icons.checklist_outlined,
                    size: 20.sp,
                    color: ColorsManger.primaryColor,
                  ),
                ),
                horizontalSpace(8),
              ],
              IconButton(
                onPressed: () {
                  context.read<EmployeeCubit>().exportEmployeesToExcel();
                },
                icon: Icon(
                  Icons.share,
                  size: 20.sp,
                  color: ColorsManger.primaryColor,
                ),
              ),
            ],
          ),
          verticalSpace(10),
        ],
      ),
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
