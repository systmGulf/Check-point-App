import 'package:easy_localization/easy_localization.dart';
import 'package:hr_management_system_package/core/common_methods/fcm_notification_service.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../controllers/mange_employee_cubit/employee_cubit.dart';

class AddEmployeeBlocListener extends StatelessWidget {
  const AddEmployeeBlocListener(
      {super.key,
      required this.deviceToken,
      required this.userName,
      required this.password,
      required this.requestId});
  final String deviceToken;
  final String userName, password;
  final int requestId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCubit, EmployeeState>(
        listenWhen: (previous, current) =>
            current is AddEmployeeSuccess ||
            current is AddEmployeeFailure ||
            current is AddEmployeeLoading,
        listener: (context, state) {
          if (state is AddEmployeeSuccess) {
            context.pop();
            context.pop();

            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(
                message: 'User Added Successfully'.tr(context: context),
                // backgroundColor: Colors.red,
              ),
            );
            context
                .read<EmployeeCubit>()
                .deleteAddAccountRequest(id: requestId);
            FcmNotificationService.sendNotification(
                deviceToken,
                'Your account has been created'.tr(context: context),
                '${"your userName is".tr(context: context)} : $userName , ${"your Password is".tr(context: context)} : $password ');
          } else if (state is AddEmployeeFailure) {
            context.pop();
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: state.error,
                // backgroundColor: Colors.red,
              ),
            );
          } else if (state is AddEmployeeLoading) {
            customLoadingIndicator(context);
          }
        },
        child: const SizedBox.shrink());
  }
}
