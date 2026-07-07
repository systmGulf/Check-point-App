import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../../../../../core/widgets/custom_loading_indicator.dart';

class AddShiftBlocListener extends StatelessWidget {
  const AddShiftBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShiftsAndPolicesCubit, ShiftsAndPolicesState>(
      listenWhen: (previous, current) =>
          current is AddShiftSuccess ||
          current is AddShiftError ||
          current is AddShiftLoading,
      listener: (context, state) {
        if (state is AddShiftSuccess) {
          context.pop();
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Shift Added Successfully'.tr(context: context),
            ),
          );
        } else if (state is AddShiftError) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
            ),
          );
        } else {
          customLoadingIndicator(context);
        }
      },
      child: SizedBox.shrink(),
    );
  }
}
