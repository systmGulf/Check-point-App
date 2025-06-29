import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/build_alart_message.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:employee_mangement/core/widgets/custom_floating_action_button.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/atomic_ui/atoms/company_branch_item.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/branch_cubit/branch_cubit.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/styles/styles.dart';
import '../molecules/add_branches_to_shifts_model_bottom_sheet.dart';

class AddBranchesToShiftScreen extends StatelessWidget {
  const AddBranchesToShiftScreen({super.key, required this.shiftId});
  final int shiftId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: CustomFloatingActionButton(
            text: 'Add Branch'.tr(context: context),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<BranchCubit>()
                              ..getBranches(isLoading: true),
                          ),
                          BlocProvider.value(
                            value: context.read<ShiftsAndPolicesCubit>(),
                          ),
                        ],
                        child: AddBranchesToShiftsModalBottomSheet(
                          shiftId: shiftId,
                        ),
                      ),
                    );
                  });
            }),
        appBar: buildCustomAppBar(
            context, 'Add Branches to Shift'.tr(context: context)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'branches in this Shift'.tr(context: context),
                style: AppStylesManger.font16BoldBlack
                    .copyWith(color: Colors.grey),
              ),
            ),
            CompanyBranchItem(
              name: 'name',
              location: 'location',
              decoration: ' sd',
              onDelete: () {
                buildAlertDialog(
                  context,
                  title: 'Delete Branch from this Shift'.tr(context: context),
                  message:
                      'Are you sure you want to delete this branch from this Shift?'
                          .tr(context: context),
                  onYes: () {},
                );
              },
            )
          ],
        ));
  }
}
