import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../../core/common/ask_admin_to_change_device_id_dialog.dart';
import '../../../../../../../core/contoller/roles_login_cubit/login_cubit.dart';
import '../../../../../../../core/helpers/extention.dart';
import '../../../../../../../core/routing/routes.dart';
import '../../../../../../../core/widgets/custom_loading_indicator.dart';

class EmployeeLoginBlocListener extends StatelessWidget {
  const EmployeeLoginBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (_, current) =>
          current is LoginSuccess ||
          current is LoginFailure ||
          current is LoginLoading,
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.pop();
          // FirebaseMessaging.instance.subscribeToTopic('all');
          context.pushAndRemoveUntilName(Routes.employeeHomeScreen);
        } else if (state is LoginFailure) {
          context.pop();
           if(state.error == "This devise doesn't have access to login"){
              AskAdminToChnageDeviceIdDialog(context);
              
            }
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error.tr(context: context),
            ),
          );
        } else if (state is LoginLoading) {
          customLoadingIndicator(context);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
