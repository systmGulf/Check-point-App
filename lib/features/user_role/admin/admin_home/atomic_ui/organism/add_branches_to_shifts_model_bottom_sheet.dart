
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import '../molecules/add_branches_to_shifts_model_bottom_sheet.dart';

class AssignShiftsButtonBlocConsumer extends StatelessWidget {
  const AssignShiftsButtonBlocConsumer({
    super.key,
    required this.widget,
  });

  final AddBranchesToShiftsModalBottomSheet widget;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShiftsAndPolicesCubit, ShiftsAndPolicesState>(
      listener: (context, state) {
        if (state is AssignShiftSuccess) {
       
          buildSnackBar(context, customSnackBar: CustomSnackBar.success(message: 'Shifts assigned successfully'.tr(context: context)));
        } else if (state is AssignShiftError) {
          buildSnackBar(context, customSnackBar: CustomSnackBar.error(message: state.error));
        }
      },
      builder: (context, state) {
        if (state is AssignShiftLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorsManger.primaryColor,
              strokeWidth: 2,
              backgroundColor: Colors.white,
            ),
          );
        } 
         else if (state is AssignShiftSuccess) {
          context.pop();
        }
        return  CustomAppButton(
          onPressed: () {
            context
                .read<ShiftsAndPolicesCubit>()
                .assignBranchesToShift(shiftId: widget.shiftId);
          },
          textButton: 'Add'.tr(context: context),
          buttonColor: ColorsManger.primaryColor,
        );
      },
    );
  }
}
