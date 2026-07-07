import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/app_spaces.dart';
import '../../../../core/styles/colors.dart';
import '../../../../core/styles/styles.dart';

class AuthLoginBody extends StatelessWidget {
  const AuthLoginBody({
    super.key,
    required this.roleLabel,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.formChild,
    this.footer,
  });

  final String roleLabel;
  final String title;
  final String subtitle;
  final String imageAsset;
  final Widget formChild;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.fromSTEB(20.w, 18.h, 20.w, 24.h),
        child: Column(
          children: [
            _AuthHeroCard(
              roleLabel: roleLabel,
              title: title,
              subtitle: subtitle,
              imageAsset: imageAsset,
            ),
            verticalSpace(20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28.r),
                boxShadow: [
                  BoxShadow(
                    color: ColorsManger.primaryColor.withValues(alpha: 0.10),
                    blurRadius: 30,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: formChild,
            ),
            if (footer != null) ...[
              verticalSpace(16),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}

class _AuthHeroCard extends StatelessWidget {
  const _AuthHeroCard({
    required this.roleLabel,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  });

  final String roleLabel;
  final String title;
  final String subtitle;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            ColorsManger.primaryColor,
            ColorsManger.primaryColorLight,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: ColorsManger.primaryColor.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Text(
                    roleLabel,
                    style: AppStylesManger.font12RegularBlack.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                verticalSpace(16),
                Text(
                  title,
                  style: AppStylesManger.font26BoldWhite.copyWith(
                    height: 1.2,
                  ),
                ),
                verticalSpace(8),
                Text(
                  subtitle,
                  style: AppStylesManger.font14RegularWhite.copyWith(
                    height: 1.5,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(14),
          Container(
            width: 96.w,
            height: 96.w,
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: Image.asset(
              imageAsset,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
