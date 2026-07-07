import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/animations/animations.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../core/styles/styles.dart';
import '../constants/auth_animation_constants.dart';

class AuthHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? label;

  const AuthHeaderWidget({
    required this.title,
    required this.subtitle,
    this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: ColorsManger.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              label!,
              style: AppStylesManger.font12RegularBlack.copyWith(
                color: ColorsManger.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: AuthAnimationConstants.verticalSpaceMedium),
        ],
        AnimatedTextWidget(
          text: title,
          style: AppStylesManger.font24RegularBlack.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
            height: 1.2,
          ),
          textAlign: TextAlign.start,
          delayDuration: AuthAnimationConstants.headerDelay,
        ),
        SizedBox(height: AuthAnimationConstants.verticalSpaceSmall),
        AnimatedTextWidget(
          text: subtitle,
          style: AppStylesManger.font14RegularBlack
              .copyWith(color: Colors.black54, fontSize: 14.sp, height: 1.5),
          textAlign: TextAlign.start,
          delayDuration: AuthAnimationConstants.subtitleDelay,
        ),
      ],
    );
  }
}
