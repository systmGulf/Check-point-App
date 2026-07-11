import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';

class EditUserDataBlocListener extends StatelessWidget {
  const EditUserDataBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCubit, EmployeeState>(
      listenWhen: (previous, current) =>
          current is EditEmployeeSuccess ||
          current is EditEmployeeFailure ||
          current is EditEmployeeLoading,
      listener: (context, state) {
        if (state is EditEmployeeSuccess) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
             CustomSnackBar.success(
              message: 'User Updated Successfully'.tr(),
              // backgroundColor: Colors.red,
            ),
          );
        } else if (state is EditEmployeeFailure) {
          context.pop();

          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
              // backgroundColor: Colors.red,
            ),
          );
        } else if (state is EditEmployeeLoading) {
         customLoadingIndicator(context);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
