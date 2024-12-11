import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/helpers/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../../core/contoller/roles_login_cubit/login_cubit.dart';
import '../../../../../../../core/routing/routes.dart';

class AdminLoginBlocListener extends StatelessWidget {
  const AdminLoginBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) =>
            current is LoginSuccess ||
            current is LoginFailure ||
            current is LoginLoading,
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.pop();
            // FirebaseMessaging.instance.subscribeToTopic('all');
            context.pushAndRemoveUntilName(Routes.adminHomeScreen);
          } else if (state is LoginFailure) {
            context.pop();
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: state.error.tr(context: context),
              ),
            );
          } else if (state is LoginLoading) {
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
        child: const SizedBox.shrink());
  }
}
