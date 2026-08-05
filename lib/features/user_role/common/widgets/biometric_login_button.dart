import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/colors.dart';

class BiometricLoginButton extends StatelessWidget {
  const BiometricLoginButton({
    super.key,
    required this.savedEmail,
    required this.onPressed,
    this.showDivider = true,
  });

  final String savedEmail;
  final VoidCallback onPressed;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDivider) ...[
          SizedBox(height: 16.h),
          Row(
            children: [
              const Expanded(
                child: Divider(
                  color: Color(0xFFE2E8F0),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Text(
                  'or continue with'.tr(),
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Expanded(
                child: Divider(
                  color: Color(0xFFE2E8F0),
                  thickness: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30.r),
          child: Container(
            height: 52.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: ColorsManger.primaryColor.withOpacity(0.25),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorsManger.primaryColor.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Soft primary red circle container for fingerprint icon
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: ColorsManger.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.fingerprint_rounded,
                    color: ColorsManger.primaryColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Sign in with Biometrics'.tr(),
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
