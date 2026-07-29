import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

class AssignShiftToEmployeesBottomSheet extends StatefulWidget {
  final List<String> employeeIds;
  final VoidCallback onSuccess;

  const AssignShiftToEmployeesBottomSheet({
    super.key,
    required this.employeeIds,
    required this.onSuccess,
  });

  @override
  State<AssignShiftToEmployeesBottomSheet> createState() =>
      _AssignShiftToEmployeesBottomSheetState();
}

class _AssignShiftToEmployeesBottomSheetState
    extends State<AssignShiftToEmployeesBottomSheet> {
  int? selectedShiftId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<ShiftsAndPolicesCubit>().getShifts(isLoading: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: BlocConsumer<ShiftsAndPolicesCubit, ShiftsAndPolicesState>(
        listener: (context, state) {
          if (state is GetPoliceByShiftIDSuccess) {
            final policies = state.policeResponse.value?.data ?? [];
            if (policies.isEmpty) {
              setState(() => isLoading = false);
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.error(
                  message: 'This shift has no active policy configured. Add a policy to this shift first.'.tr(),
                ),
              );
            } else {
              // Assign to the first policy found
              final policyId = policies.first.id!;
              context.read<ShiftsAndPolicesCubit>().employeesIds = widget.employeeIds;
              context.read<ShiftsAndPolicesCubit>().assignEmployeesToPolice(policeId: policyId);
            }
          } else if (state is AssignPoliceSuccess) {
            setState(() => isLoading = false);
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(
                message: 'Employees assigned to shift successfully'.tr(),
              ),
            );
            widget.onSuccess();
            context.pop();
          } else if (state is GetPoliceByShiftIDError || state is AssignPoliceError) {
            setState(() => isLoading = false);
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: 'An error occurred during shift assignment'.tr(),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ShiftsAndPolicesCubit>();
          final shiftList = cubit.state is GetShiftsSuccess
              ? (cubit.state as GetShiftsSuccess).shiftModel.value?.data ?? []
              : [];

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Shift to Assign'.tr(),
                style: AppStylesManger.font16BoldBlack,
              ),
              const SizedBox(height: 15),
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (shiftList.isEmpty)
                Center(
                  child: Text('No shifts available'.tr()),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: shiftList.length,
                  itemBuilder: (context, index) {
                    final shift = shiftList[index];
                    final isSelected = selectedShiftId == shift.id;
                    return Card(
                      color: isSelected ? ColorsManger.primaryColor.withOpacity(0.1) : Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: isSelected ? ColorsManger.primaryColor : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.work_history,
                          color: isSelected ? ColorsManger.primaryColor : Colors.grey,
                        ),
                        title: Text(
                          shift.name ?? '',
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            selectedShiftId = shift.id;
                          });
                        },
                      ),
                    );
                  },
                ),
              const SizedBox(height: 20),
              if (!isLoading)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        child: Text('Cancel'.tr()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomAppButton(
                        buttonColor: ColorsManger.primaryColor,
                        textButton: 'Assign'.tr(),
                        onPressed: selectedShiftId == null
                            ? null
                            : () {
                                setState(() => isLoading = true);
                                context.read<ShiftsAndPolicesCubit>().getPoliceByShiftId(
                                      shiftId: selectedShiftId!,
                                      isLoading: false,
                                    );
                              },
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
