import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/core/common_methods/network_checker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../core/helpers/app_spaces.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/widgets/progress_loading_bar.dart';

class SplashScreenBody extends StatefulWidget {
  const SplashScreenBody({super.key});

  @override
  State<SplashScreenBody> createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBody> {
  NetworkChecker commonMehtods = NetworkChecker();
  @override
  void initState() {
    navigateToLogin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        const Align(
          alignment: Alignment.center,
          child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/app_logo.png')),
        ),
        const Spacer(),
        const Align(alignment: Alignment.center, child: ProgressLoadingBar()),
        verticalSpace(30)
      ],
    );
  }

  void navigateToLogin(BuildContext context) async {
    commonMehtods.checkConnectivity(onFailure: () {
      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: "Please check your internet connection and try again",
            ),
          );
        }
      });
    }, onSuccess: () {
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          context.pushReplacementName(Routes.onboardingscreen);
        }
      });
    });
  }
}
