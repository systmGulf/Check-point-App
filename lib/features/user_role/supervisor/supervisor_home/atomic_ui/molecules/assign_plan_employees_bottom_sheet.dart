import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import '../../contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';
import 'multi_select_drop_down.dart';

class AssignPlanEmployeesBottomSheet extends StatefulWidget {
  const AssignPlanEmployeesBottomSheet({
    super.key,
    required this.planId,
  });

  final String planId;

  @override
  State<AssignPlanEmployeesBottomSheet> createState() =>
      _AssignPlanEmployeesBottomSheetState();
}

class _AssignPlanEmployeesBottomSheetState
    extends State<AssignPlanEmployeesBottomSheet> {
  @override
  void initState() {
    super.initState();
    context.read<PlanCubit>().dropdownItems = [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlanCubit, PlanState>(
      listener: (context, state) {
        if (state is SetSubPlanSuccess) {
          Navigator.pop(context);
          buildSnackBar(
            context,
            customSnackBar: CustomSnackBar.success(
              message: 'Plan assigned successfully'.tr(context: context),
            ),
          );
        } else if (state is SetSubPlanError) {
          buildSnackBar(
            context,
            customSnackBar: CustomSnackBar.error(
              message: state.error,
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6D6D6),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                verticalSpace(16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assign Plan'.tr(context: context),
                            style: AppStylesManger.font16BoldBlack,
                          ),
                          verticalSpace(4),
                          Text(
                            'Select employees to assign this plan'
                                .tr(context: context),
                            style: AppStylesManger.font12RegularGrey,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                verticalSpace(16),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    '${'Plan ID'.tr(context: context)}: ${widget.planId}',
                    style: AppStylesManger.font12RegularGrey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                verticalSpace(18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE8E8E8)),
                  ),
                  child:
                      BlocBuilder<GetEmployeesDataCubit, GetEmployeesDataState>(
                    builder: (context, state) {
                      if (state is GetAllEmployeesLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (state is GetAllEmployeesFailure) {
                        return Text(
                          state.errorMsg,
                          style: AppStylesManger.font12RegularGrey,
                        );
                      }
                      if (state is GetAllEmployeesSuccess &&
                          (state.allEmployeesValue.data?.isEmpty ?? true)) {
                        return NoDataFound();
                      }
                      return const MultiSelectEmployeesDropdown();
                    },
                  ),
                ),
                verticalSpace(20),
                BlocBuilder<PlanCubit, PlanState>(
                  builder: (context, state) {
                    final loading = state is SetSubPlanLoading;
                    return CustomAppButton(
                      onPressed: loading
                          ? null
                          : () {
                              context
                                  .read<PlanCubit>()
                                  .assignPlanToSelectedEmployees(
                                    planId: widget.planId,
                                  );
                            },
                      textButton: loading
                          ? 'Assigning...'.tr(context: context)
                          : 'Assign Plan'.tr(context: context),
                      buttonColor: ColorsManger.primaryColor,
                    );
                  },
                ),
                verticalSpace(8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
