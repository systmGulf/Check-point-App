import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/styles/styles.dart';

class TextTermsAndCondition extends StatelessWidget {
  const TextTermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: 'By signing in you agree to our'.tr(),
            style: AppStylesManger.font11clamgrey400weight),
        TextSpan(
            text: ' Terms & Conditions'.tr(),
            style: AppStylesManger.font11clamgrey400weight.copyWith(
                color: ColorsManger.darkblue,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        TextSpan(
          text: ' and '.tr(),
          style: AppStylesManger.font11clamgrey400weight,
        ),
        TextSpan(
            text: 'Privacy Policy'.tr(),
            style: AppStylesManger.font11clamgrey400weight.copyWith(
                color: ColorsManger.darkblue,
                fontSize: 12,
                height: 2,
                fontWeight: FontWeight.w600))
      ]),
      textAlign: TextAlign.center,
    );
  }
}
