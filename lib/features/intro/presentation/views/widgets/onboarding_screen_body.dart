import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helpers/app_spaces.dart';
import '../../../../../core/helpers/extention.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../core/styles/styles.dart';
import '../../../../../core/widgets/build_change_language_bottom_sheet.dart';
import '../../cubit/register_account/register_account_cubit.dart';
import '../../../../../core/animations/animations.dart';
import 'register_account_bloc_listener.dart';
import 'register_account_dialog.dart';

class OnboardingScreenBody extends StatelessWidget {
  const OnboardingScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Background gradient ──────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFE8EFFE),
                const Color(0xFFD6E3FB),
                Colors.white,
              ],
            ),
          ),
        ),

        // ── Decorative blobs ────────────────────────────────────────────
        const _DecorativeBlobs(),

        SafeArea(
          child: Column(
            children: [
              // ── Language button ────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: _LanguageButton(),
                ),
              ),

              // ── Illustration ──────────────────────────────────────────
              Expanded(
                child: Center(
                  child: AnimatedByWidgetType(
                    widgetType: WidgetAnimationType.image,
                    child: const _TeamNetworkIllustration(),
                  ),
                ),
              ),

              // ── Bottom card ───────────────────────────────────────────
              AnimatedByWidgetType(
                widgetType: WidgetAnimationType.container,
                delayDuration: const Duration(milliseconds: 200),
                child: _BottomCard(),
              ),
            ],
          ),
        ),

        const RegisterAccountBlocListener(),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Language button
// ─────────────────────────────────────────────────────────────────────────────
class _LanguageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => buildChangeLanguageBottomSheet(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language_rounded,
                size: 16.sp, color: ColorsManger.primaryColor),
            horizontalSpace(6),
            Text(
              'language'.tr(),
              style: TextStyle(
                color: ColorsManger.primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Team network illustration  (3 avatar circles connected by dashed lines)
// ─────────────────────────────────────────────────────────────────────────────
class _TeamNetworkIllustration extends StatelessWidget {
  const _TeamNetworkIllustration();

  @override
  Widget build(BuildContext context) {
    final double circleSize = 68.r;
    final double smallSize = 58.r;

    return SizedBox(
      width: 230.w,
      height: 200.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dashed connector lines
          Positioned.fill(
            child: CustomPaint(painter: _NetworkLinesPainter()),
          ),

          // Top-center – blue (manager)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(child: _AvatarCircle(size: circleSize, color: ColorsManger.primaryColor)),
          ),

          // Bottom-left – teal
          Positioned(
            bottom: 0,
            left: 10.w,
            child: _AvatarCircle(size: smallSize, color: const Color(0xFF2BBFBF)),
          ),

          // Bottom-right – orange
          Positioned(
            bottom: 0,
            right: 10.w,
            child: _AvatarCircle(size: smallSize, color: const Color(0xFFF5A623)),
          ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color, width: 2.5),
      ),
      child: Icon(Icons.person_rounded, color: color, size: size * 0.55),
    );
  }
}

/// Draws dashed lines between the three avatar positions
class _NetworkLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF295BDD).withValues(alpha: 0.25)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Centers (approximate, matching Stack positions)
    final top = Offset(size.width / 2, size.height * 0.17);
    final bottomLeft = Offset(size.width * 0.2, size.height * 0.83);
    final bottomRight = Offset(size.width * 0.8, size.height * 0.83);

    _drawDashed(canvas, paint, top, bottomLeft);
    _drawDashed(canvas, paint, top, bottomRight);
    _drawDashed(canvas, paint, bottomLeft, bottomRight);
  }

  void _drawDashed(Canvas canvas, Paint paint, Offset start, Offset end) {
    const dashLen = 6.0;
    const gapLen = 5.0;
    final total = (end - start).distance;
    double drawn = 0;
    final dir = (end - start) / total;
    while (drawn < total) {
      final s = start + dir * drawn;
      final e = start + dir * (drawn + dashLen).clamp(0.0, total);
      canvas.drawLine(s, e, paint);
      drawn += dashLen + gapLen;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom sheet card
// ─────────────────────────────────────────────────────────────────────────────
class _BottomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // "enlighten" badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: ColorsManger.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              'enlighten'.tr(),
              style: TextStyle(
                color: ColorsManger.primaryColor,
                fontWeight: FontWeight.w800,
                fontSize: 12.sp,
              ),
            ),
          ),
          verticalSpace(14),

          // Headline
          Text(
            'Workforce management made simple'.tr(),
            style: AppStylesManger.font14BoldRed.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              height: 1.25,
              color: const Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),
          verticalSpace(10),

          // Subtitle
          Text(
            'Check in, coordinate teams, and manage daily operations from one secure workspace.'.tr(),
            style: TextStyle(
              color: Colors.black54,
              fontSize: 13.sp,
              height: 1.6,
            ),
          ),
          verticalSpace(20),

          // Feature chips
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: [
              _FeatureChip(label: 'Daily attendance'.tr(), icon: Icons.access_time_rounded),
              _FeatureChip(label: 'Task tracking'.tr(), icon: Icons.check_circle_outline_rounded),
              _FeatureChip(label: 'Team control'.tr(), icon: Icons.groups_outlined),
            ],
          ),
          verticalSpace(24),

          // Get started button
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton.icon(
              onPressed: () => context.pushName(Routes.userRoleScreen),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManger.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              icon: const Text('✨', style: TextStyle(fontSize: 18)),
              label: Text(
                'get_started'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          verticalSpace(12),

          // Register link
          Center(
            child: TextButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (_) {
                    return BlocProvider.value(
                      value: context.read<RegisterAccountCubit>(),
                      child: AnimatedDialogWidget(
                        child: const RegisterAccountDialog(),
                      ),
                    );
                  },
                );
              },
              child: Text.rich(
                TextSpan(
                  text: 'Ask Admin to Create Account  '.tr(),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13.sp,
                  ),
                  children: [
                    TextSpan(
                      text: 'register'.tr(),
                      style: TextStyle(
                        color: ColorsManger.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 13.sp,
                        decoration: TextDecoration.underline,
                        decorationColor: ColorsManger.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Feature chip
// ─────────────────────────────────────────────────────────────────────────────
class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          horizontalSpace(6),
          Icon(icon, size: 15.sp, color: ColorsManger.primaryColor),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Decorative blobs
// ─────────────────────────────────────────────────────────────────────────────
class _DecorativeBlobs extends StatelessWidget {
  const _DecorativeBlobs();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-left blob
        Positioned(
          top: -80,
          left: -60,
          child: _Blob(
            size: 200,
            color: ColorsManger.primaryColor.withValues(alpha: 0.12),
          ),
        ),
        // Top-right blob
        Positioned(
          top: 30,
          right: -70,
          child: _Blob(
            size: 160,
            color: ColorsManger.primaryColor.withValues(alpha: 0.08),
          ),
        ),
        // Bottom-right blob
        Positioned(
          bottom: 260,
          right: -90,
          child: _Blob(
            size: 200,
            color: const Color(0xFF9EC9F5).withValues(alpha: 0.35),
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
