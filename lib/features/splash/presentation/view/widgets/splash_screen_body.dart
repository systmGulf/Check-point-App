import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/core/common_methods/network_checker.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../../../../core/helpers/app_spaces.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../core/widgets/progress_loading_bar.dart';

class SplashScreenBody extends StatefulWidget {
  const SplashScreenBody({super.key});

  @override
  State<SplashScreenBody> createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBody> {
  NetworkChecker commonMethods = NetworkChecker();
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
        Container(
          width: 220.w,
          height: 120.h,
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: ColorsManger.primaryColor.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Image.asset(
            Assets.AppLogoImage,
            fit: BoxFit.contain,
          ),
        ),
        const Spacer(),
        const Align(alignment: Alignment.center, child: ProgressLoadingBar()),
        verticalSpace(30)
      ],
    );
  }

  void navigateToLogin(BuildContext context) async {
    commonMethods.checkConnectivity(onFailure: () {
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
