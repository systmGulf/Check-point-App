import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/branch_cubit/branch_cubit.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                return MultiDropdown<String>(
                  items: List.generate(
                      state.branches.data!.length,
                      (index) => DropdownItem<String>(
                          label: state.branches.data![index].name.toString(),
                          value: state.branches.data![index].id.toString())),
                  controller: controller,
                  enabled: true,
                  fieldDecoration: FieldDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'select branches'.tr(context: context),
                  ),
                  searchEnabled: true,
                  searchDecoration: SearchFieldDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Search'.tr(context: context),
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
                    context.read<ShiftsAndPolicesCubit>().branchesIds =
                        List<int>.generate(selectedItems.length,
                            (index) => int.parse(selectedItems[index]));
                  },
                );
              } else if (state is GetBranchError) {
                return Center(
                  child: Text(state.error),
                );
              } else {
                return SizedBox();
              }
            },
          ),
          verticalSpace(20),
          AssignShiftsButtonBlocConsumer(widget: widget)
        ],
      ),
    );
  }
}
