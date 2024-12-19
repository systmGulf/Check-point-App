import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/widgets/custom_loading_indicator.dart';

class AddShiftBlocListener extends StatelessWidget {
  const AddShiftBlocListener({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocListener<ShiftsAndPolicesCubit, ShiftsAndPolicesState>(
        listenWhen: (previous, current) => current is AddShiftSuccess || current is AddShiftError || current is AddShiftLoading, 
      listener: (context, state) {
        if (state is AddShiftSuccess) {
          Navigator.pop(context);
          showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(
                message: 'Shift Added Successfully'.tr(context: context),
                // backgroundColor: Colors.red,
              ),
            );
        } else if (state is AddShiftError) {
          Navigator.pop(context);
          showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: state.error,
                // backgroundColor: Colors.red,
              ),
            );
        }   else{
            customLoadingIndicator(context);
        }
      },
      child: SizedBox.shrink(), 
    );
  }
}