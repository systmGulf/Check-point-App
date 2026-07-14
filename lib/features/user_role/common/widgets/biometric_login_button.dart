import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/colors.dart';
import '../../../../core/styles/styles.dart';

class BiometricLoginButton extends StatelessWidget {
  const BiometricLoginButton({
    super.key,
    required this.savedEmail,
    required this.onPressed,
  });

  final String savedEmail;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorsManger.primaryColor,
        side: BorderSide(
          color: ColorsManger.primaryColor.withValues(alpha: 0.35),
        ),
        backgroundColor: Colors.white,
        minimumSize: Size(double.infinity, 52.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      icon: Icon(
        Icons.fingerprint_rounded,
        color: ColorsManger.primaryColor,
        size: 24.sp,
      ),
      label: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sign in with biometrics'.tr(),
            style: AppStylesManger.font16blackMedium.copyWith(
              color: ColorsManger.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            savedEmail,
            style: AppStylesManger.font12RegularGrey.copyWith(
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
