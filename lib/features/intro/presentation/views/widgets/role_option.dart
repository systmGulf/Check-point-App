import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    this.isActive = false,
  });

  final String roleOptionText, roleImage, roleDescription, roleTag;
  final void Function()? onTap;

  /// When true the image container uses a solid blue background (first/Employee card)
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isActive
                ? ColorsManger.primaryColor.withValues(alpha: 0.35)
                : Colors.grey.shade200,
            width: isActive ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Arrow icon ──────────────────────────────────────────────
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 14.sp,
              color: Colors.grey.shade400,
            ),
            horizontalSpace(12),

            // ── Text content ────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: ColorsManger.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      roleTag,
                      style: AppStylesManger.font11RegularBlack.copyWith(
                        color: ColorsManger.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                  verticalSpace(6),

                  // Role name
                  Text(
                    roleOptionText,
                    style: TextStyle(
                      color: const Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w800,
                      fontSize: 18.sp,
                    ),
                  ),
                  verticalSpace(2),

                  // Description
                  Text(
                    roleDescription,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12.sp,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            horizontalSpace(12),

            // ── Role image ──────────────────────────────────────────────
            Container(
              width: 60.w,
              height: 60.w,
              padding: EdgeInsets.all(isActive ? 10.r : 12.r),
              decoration: BoxDecoration(
                color: isActive
                    ? ColorsManger.primaryColor
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Image.asset(
                roleImage,
                fit: BoxFit.contain,
                color: isActive ? Colors.white : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
