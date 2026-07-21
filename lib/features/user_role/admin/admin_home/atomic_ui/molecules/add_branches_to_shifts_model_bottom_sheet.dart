import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/core/widgets/app_action_icon_button.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/branch_cubit/branch_cubit.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../organism/add_branches_to_shifts_model_bottom_sheet.dart';

class AddBranchesToShiftsModalBottomSheet extends StatefulWidget {
  const AddBranchesToShiftsModalBottomSheet({
    super.key,
    required this.shiftId,
  });
  final int shiftId;

  @override
  State<AddBranchesToShiftsModalBottomSheet> createState() =>
      _AddBranchesToShiftsModalBottomSheetState();
}

class _AddBranchesToShiftsModalBottomSheetState
    extends State<AddBranchesToShiftsModalBottomSheet> {
  final controller = MultiSelectController<String>();
  bool isSelectAllBranches = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Branches to Shift'.tr(),
                style: AppStylesManger.font16BoldBlack,
              ),
              AppActionIconButton.delete(
                onPressed: () {
                  context.pop();
                },
                size: 34,
                backgroundColor: Colors.white,
                iconColor: ColorsManger.primaryColor,
              ),
            ],
          ),
          verticalSpace(10.h),
          BlocBuilder<BranchCubit, BranchState>(
            bloc: context.read<BranchCubit>(),
            buildWhen: (previous, current) =>
                current is GetBranchError ||
                current is GetBranchSuccess ||
                current is GetBranchLoading,
            builder: (context, state) {
              if (state is GetBranchLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorsManger.primaryColor,
                    strokeWidth: 2,
                    backgroundColor: Colors.white,
                  ),
                );
              } else if (state is GetBranchSuccess) {
                final branchesData = state.branches.data ?? [];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSelectAllBranches = !isSelectAllBranches;
                          _handleSelectAllToggle(branchesData);
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 4.0),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isSelectAllBranches,
                              activeColor: ColorsManger.primaryColor,
                              onChanged: (val) {
                                setState(() {
                                  isSelectAllBranches = val ?? false;
                                  _handleSelectAllToggle(branchesData);
                                });
                              },
                            ),
                            horizontalSpace(4.w),
                            Text(
                              'Assign to All Company Branches'.tr(),
                              style: AppStylesManger.font15BoldBlack.copyWith(
                                color: ColorsManger.primaryColor,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalSpace(10.h),
                    MultiDropdown<String>(
                      items: List.generate(
                          branchesData.length,
                          (index) => DropdownItem<String>(
                              label: branchesData[index].name.toString(),
                              value: branchesData[index].id.toString())),
                      controller: controller,
                      enabled: !isSelectAllBranches,
                      fieldDecoration: FieldDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: isSelectAllBranches
                            ? 'All Company Branches Selected'.tr()
                            : 'select branches'.tr(),
                      ),
                      searchEnabled: true,
                      searchDecoration: SearchFieldDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Search'.tr(),
                      ),
                      chipDecoration: ChipDecoration(
                        backgroundColor: ColorsManger.primaryColor,
                        wrap: true,
                        runSpacing: 2,
                        labelStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        deleteIcon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        spacing: 10,
                      ),
                      onSelectionChange: (selectedItems) {
                        if (!isSelectAllBranches) {
                          context.read<ShiftsAndPolicesCubit>().branchesIds =
                              List<int>.generate(selectedItems.length,
                                  (index) => int.parse(selectedItems[index]));
                        }
                      },
                    ),
                  ],
                );
              } else if (state is GetBranchError) {
                return Center(
                  child: Text(state.error),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          verticalSpace(20),
          AssignShiftsButtonBlocConsumer(widget: widget)
        ],
      ),
    );
  }

  void _handleSelectAllToggle(List branchesData) {
    if (isSelectAllBranches) {
      final allIds = branchesData
          .where((b) => b.id != null)
          .map<int>((b) => b.id!)
          .toList();
      context.read<ShiftsAndPolicesCubit>().branchesIds = allIds;
    } else {
      context.read<ShiftsAndPolicesCubit>().branchesIds = [];
    }
  }
}
