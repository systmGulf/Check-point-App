import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/app_spaces.dart';
import '../../../../core/styles/colors.dart';

/// Shared login screen shell used by all three roles.
/// Provides a gradient background, decorative blobs, and a scrollable content area.
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE8EFFE), Color(0xFFD6E3FB), Colors.white],
        ),
      ),
      child: Stack(
        children: [
          // Decorative blobs
          _DecorativeBlobs(),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back arrow
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16.sp,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  verticalSpace(32),

                  // Role badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: ColorsManger.primaryColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      roleLabel,
                      style: TextStyle(
                        color: ColorsManger.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  verticalSpace(14),

                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w900,
                      fontSize: 26.sp,
                      height: 1.2,
                    ),
                  ),
                  verticalSpace(8),

                  // Subtitle
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13.sp,
                      height: 1.6,
                    ),
                  ),
                  verticalSpace(32),

                  // Form content
                  formChild,

                  if (footer != null) ...[ 
                    verticalSpace(16),
                    footer!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Decorative blobs (same as onboarding/role screens)
// ─────────────────────────────────────────────────────────────────────────────
class _DecorativeBlobs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -90,
          left: -60,
          child: _Blob(
            size: 200,
            color: ColorsManger.primaryColor.withValues(alpha: 0.10),
          ),
        ),
        Positioned(
          top: 60,
          right: -80,
          child: _Blob(
            size: 160,
            color: ColorsManger.primaryColor.withValues(alpha: 0.07),
          ),
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
