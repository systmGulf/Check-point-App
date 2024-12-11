import 'package:flutter/material.dart';

import '../../../../../core/common/common_methods.dart';
import '../../../../../core/helpers/app_spaces.dart';
import '../../../../../core/widgets/progress_loading_bar.dart';

class SplashScreenBody extends StatefulWidget {
  const SplashScreenBody({super.key});

  @override
  State<SplashScreenBody> createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBody> {
  CommonMethods commonMehtods = CommonMethods();
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
    commonMehtods.checkConnectivity(context);
  }
}
