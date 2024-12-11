import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DeleteUserBlocListener extends StatelessWidget {
  const DeleteUserBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCubit, EmployeeState>(
        listener: (context, state) {
          if (state is DeleteUserAccountSuccess) {
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(
                message: 'User Deleted Successfully'.tr(context: context),
                // backgroundColor: Colors.red,
              ),
            );
          } else if (state is DeleteUserAccountFailure) {
            context.pop();
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: state.error,
                // backgroundColor: Colors.red,
              ),
            );
          } else {}
        },
        child: const SizedBox.shrink());
  }
}
