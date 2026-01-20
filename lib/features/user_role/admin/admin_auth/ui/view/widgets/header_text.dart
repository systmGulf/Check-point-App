import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/styles/styles.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back!'.tr(),
          style: AppStylesManger.font24regularBlack
              .copyWith(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        Text(
          'Sign in to your account as Admin'.tr(),
          style: AppStylesManger.font14RegularBlack
              .copyWith(color: Colors.grey, fontSize: 14.sp),
        ),
      ],
    );
  }
}
