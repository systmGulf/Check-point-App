import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/animations/animations.dart';
import '../../../../../core/helpers/app_spaces.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../core/styles/styles.dart';

class RoleOption extends StatelessWidget {
  const RoleOption({
    super.key,
    required this.roleOptionText,
    required this.roleImage,
    this.onTap,
    required this.roleDescription,
    required this.roleTag,
  });
  final String roleOptionText, roleImage, roleDescription, roleTag;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedByWidgetType(
      widgetType: WidgetAnimationType.card,
      child: InkWell(
        borderRadius: BorderRadius.circular(26.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.r),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26.r),
            border: Border.all(
              color: ColorsManger.primaryColor.withValues(alpha: 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58.w,
                height: 58.w,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: ColorsManger.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Image.asset(
                  roleImage,
                  fit: BoxFit.contain,
                ),
              ),
              horizontalSpace(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            ColorsManger.primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        roleTag,
                        style: AppStylesManger.font11RegularBlack.copyWith(
                          color: ColorsManger.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    verticalSpace(10),
                    Text(
                      roleOptionText,
                      style: AppStylesManger.font16BoldBlack.copyWith(
                        color: ColorsManger.lightblack,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      roleDescription,
                      style: AppStylesManger.font12RegularGrey.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              horizontalSpace(8),
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: ColorsManger.primaryColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.sp,
                  color: ColorsManger.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
