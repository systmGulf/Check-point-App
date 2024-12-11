import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/helpers/extention.dart';
import '../../cubit/register_account/register_account_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../core/widgets/custom_loading_indicator.dart';

class RegisterAccountBlocListener extends StatelessWidget {
  const RegisterAccountBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterAccountCubit, RegisterAccountState>(
        listenWhen: (previous, current) =>
            current is RegisterAccountSuccess ||
            current is RegisterAccountFailure ||
            current is RegisterAccountLoading,
        listener: (context, state) {
          if (state is RegisterAccountSuccess) {
            context.pop();
            context.pop();

            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(
                message:
                    'Admin Recivied your request, you will recive notification soon'
                        .tr(context: context),
              ),
            );
          } else if (state is RegisterAccountFailure) {
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: state.errorMessage,
              ),
            );
          } else {
            customLoadingIndicator(context);
          }
        },
        child: const SizedBox.shrink());
  }
}
