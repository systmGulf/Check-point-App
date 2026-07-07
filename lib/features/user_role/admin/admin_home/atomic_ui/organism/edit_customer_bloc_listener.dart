import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../controllers/customer_cubit/customer_cubit.dart';

class EditCustomerBlocListener extends StatelessWidget {
  const EditCustomerBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerCubit, CustomerState>(
      listenWhen: (current, state) =>
          current is EditCustomerSuccess ||
          current is EditCustomerError ||
          current is EditCustomerLoading,
      listener: (context, state) {
        if (state is EditCustomerSuccess) {
          showTopSnackBar(
            Overlay.of(context),
             CustomSnackBar.success(
              message: 'Customer Edited Successfully'.tr(context: context),
              // backgroundColor: Colors.red,
            ),
          );
        } else if (state is EditCustomerError) {
          Navigator.pop(context);
          Navigator.pop(context);
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error,
              // backgroundColor: Colors.red,
            ),
          );
        } else if (state is EditCustomerLoading) {
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
      child: const SizedBox(),
    );
  }
}
