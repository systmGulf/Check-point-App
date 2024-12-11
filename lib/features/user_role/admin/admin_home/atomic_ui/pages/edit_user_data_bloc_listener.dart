import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/helpers/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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
              message: 'User Updated Successfully'.tr(context: context),
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
          showDialog(
              context: context,
              builder: (context) => OverlayLoaderWithAppIcon(
                    isLoading: true,
                    appIcon: Image.asset(
                      'assets/images/logo-w.png',
                      height: 50,
                      color: Colors.orange,
                    ),
                    circularProgressColor: Colors.orange,
                    child: Container(),
                  ));
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
