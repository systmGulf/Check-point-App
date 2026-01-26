import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/app_spaces.dart';
import '../styles/colors.dart';

class NoInternetConnectionWidget extends StatelessWidget {
  const NoInternetConnectionWidget({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/images/no-wifi.png', height: 100.h),
        Center(
            child: Text(
          'No Internet Connection'.tr(context: context),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )),
        verticalSpace(10),
        IntrinsicWidth(
          child: CustomAppButton(
              border: 10,
              onPressed: onPressed,
              textButton: 'Retry'.tr(context: context),
              buttonColor: ColorsManger.primaryColor),
        )
      ],
    );
  }
}
