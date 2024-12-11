import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../controller/change_password/change_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/widgets/custom_loading_indicator.dart';

class EmployeeChangePasswordBlocListener extends StatelessWidget {
  const EmployeeChangePasswordBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeChangePasswordCubit,
            EmployeeChangePasswordState>(
        listenWhen: (previous, current) =>
            current is ChangePasswordSuccess ||
            current is ChangePasswordFailure ||
            current is ChangePasswordLoading,
        listener: (context, state) {
          if (state is ChangePasswordFailure) {
            context.pop();
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: state.errorMsg,
                // backgroundColor: Colors.red,
              ),
            );
          } else if (state is ChangePasswordSuccess) {
            context.pop();
            context.pop();
            showTopSnackBar(
              Overlay.of(context),
               CustomSnackBar.success(
                message: "Password changed successfully".tr(context: context),
                // backgroundColor: Colors.red,
              ),
            );
          } else {
            customLoadingIndicator(context);
          }
        },
        child: const SizedBox.shrink());
  }
}
