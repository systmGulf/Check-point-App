import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/styles/styles.dart';

class EmployeeLoginImageAndText extends StatelessWidget {
  const EmployeeLoginImageAndText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back!'.tr(),
            style: AppStylesManger.font24regularBlack
                .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            'Sign in to your account as Employee'.tr(),
            style: AppStylesManger.font14RegularBlack
                .copyWith(color: Colors.grey, fontSize: 14),
          ),
          const Row(children: []),
        ],
      ),
    );
  }
}
