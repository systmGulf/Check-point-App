import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/app_spaces.dart';
import '../../../../core/styles/colors.dart';

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
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorsManger.scaffoldBackgroundColor,
            ColorsManger.lightGreen.withValues(alpha: 0.38),
            Colors.white,
          ],
        ),
      ),
      child: Stack(
        children: [
          // const _AuthDecorativeBackdrop(),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.fromSTEB(20.w, 14.h, 20.w, 20.h),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.98),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color:
                            ColorsManger.primaryColor.withValues(alpha: 0.08),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorsManger.primaryColor.withValues(
                            alpha: 0.08,
                          ),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: formChild,
                  ),
                  if (footer != null) ...[
                    verticalSpace(12),
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

class _AuthDecorativeBackdrop extends StatelessWidget {
  const _AuthDecorativeBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -180,
          left: -120,
          child: _GlowCircle(
            size: 200,
            color: ColorsManger.primaryColorLight.withValues(alpha: 0.10),
          ),
        ),
        Positioned(
          top: 180,
          right: -100,
          child: _GlowCircle(
            size: 150,
            color: ColorsManger.lightGreen.withValues(alpha: 0.18),
          ),
        ),
        Positioned(
          bottom: 130,
          left: -100,
          child: _GlowCircle(
            size: 220,
            color: ColorsManger.lighorage.withValues(alpha: 0.30),
          ),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
