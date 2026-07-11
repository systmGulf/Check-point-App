import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';

class DeleteUserBlocListener extends StatelessWidget {
  const DeleteUserBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCubit, EmployeeState>(
        listenWhen: (previous, current) =>
            current is DeleteUserAccountSuccess ||
            current is DeleteUserAccountFailure,
        listener: (context, state) {
          if (state is DeleteUserAccountSuccess) {
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(
                message: 'User Deleted Successfully'.tr(),
                // backgroundColor: Colors.red,
              ),
            );
          } else if (state is DeleteUserAccountFailure) {
            context.pop();
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: 'Something went wrong'.tr(),
              ),
            );
          } else {}
        },
        child: const SizedBox.shrink());
  }
}
