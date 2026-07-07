import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/animations/animations.dart';
import '../../../../../core/helpers/app_spaces.dart';
import '../../../../../core/helpers/extention.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../core/styles/styles.dart';
import '../../../../../core/widgets/build_change_language_bottom_sheet.dart';
import '../../../../../core/widgets/custom_app_button.dart';
import '../../cubit/register_account/register_account_cubit.dart';
import 'register_account_bloc_listener.dart';
import 'register_account_dialog.dart';

class OnboardingScreenBody extends StatelessWidget {
  const OnboardingScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorsManger.scaffoldBackgroundColor,
                ColorsManger.lightGreen.withValues(alpha: 0.6),
                Colors.white,
              ],
            ),
          ),
        ),
        const _OnboardingDecorativeBackdrop(),
        SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(22.w, 16.h, 22.w, 18.h),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: SizedBox(
                    width: 108.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: ColorsManger.primaryColor.withValues(
                            alpha: 0.10,
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          buildChangeLanguageBottomSheet(context);
                        },
                        child: Text(
                          'language'.tr(),
                          style: AppStylesManger.font14RegularBlack.copyWith(
                            color: ColorsManger.primaryColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(22.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.96),
                    borderRadius: BorderRadius.circular(34.r),
                    border: Border.all(
                      color: ColorsManger.primaryColor.withValues(alpha: 0.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            ColorsManger.primaryColor.withValues(alpha: 0.10),
                        blurRadius: 28,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    color: ColorsManger.primaryColor
                                        .withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(999.r),
                                  ),
                                  child: Text(
                                    'enlighten'.tr(),
                                    style: AppStylesManger.font12RegularBlack
                                        .copyWith(
                                      color: ColorsManger.primaryColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                verticalSpace(12),
                                Text(
                                  'Workforce management made simple'.tr(),
                                  style: AppStylesManger.font26RegularBlack
                                      .copyWith(
                                    fontWeight: FontWeight.w800,
                                    height: 1.12,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(12),
                      Text(
                        'Check in, coordinate teams, and manage daily operations from one secure workspace.'
                            .tr(),
                        style: AppStylesManger.font14RegularBlack.copyWith(
                          color: Colors.black54,
                          height: 1.6,
                        ),
                      ),
                      verticalSpace(18),
                      Wrap(
                        spacing: 10.w,
                        runSpacing: 10.h,
                        children: [
                          _OnboardingInfoChip(
                            label: 'Daily attendance'.tr(),
                            icon: Icons.access_time_rounded,
                          ),
                          _OnboardingInfoChip(
                            label: 'Task tracking'.tr(),
                            icon: Icons.check_circle_outline_rounded,
                          ),
                          _OnboardingInfoChip(
                            label: 'Team control'.tr(),
                            icon: Icons.groups_outlined,
                          ),
                        ],
                      ),
                      verticalSpace(22),
                      Row(
                        children: [
                          Expanded(
                            child: CustomAppButton(
                              onPressed: () {
                                context.pushName(Routes.userRoleScreen);
                              },
                              textButton: 'get_started'.tr(),
                              buttonColor: ColorsManger.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(10),
                      TextButton(
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
                            style: AppStylesManger.font14RegularBlack.copyWith(
                              color: Colors.black87,
                            ),
                            children: [
                              TextSpan(
                                text: 'register'.tr(),
                                style: AppStylesManger.font16BoldPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpace(12),
                const RegisterAccountBlocListener(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingInfoChip extends StatelessWidget {
  const _OnboardingInfoChip({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorsManger.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: ColorsManger.primaryColor.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: ColorsManger.primaryColor,
          ),
          horizontalSpace(8),
          Text(
            label,
            style: AppStylesManger.font12RegularBlack.copyWith(
              color: ColorsManger.lightblack,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingDecorativeBackdrop extends StatelessWidget {
  const _OnboardingDecorativeBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -90,
          left: -60,
          child: _Orb(
            size: 180,
            color: ColorsManger.primaryColorLight.withValues(alpha: 0.24),
          ),
        ),
        Positioned(
          top: 90,
          right: -70,
          child: _Orb(
            size: 150,
            color: ColorsManger.lightGreen.withValues(alpha: 0.7),
          ),
        ),
        Positioned(
          bottom: 150,
          right: -80,
          child: _Orb(
            size: 210,
            color: ColorsManger.lighorage.withValues(alpha: 0.48),
          ),
        ),
      ],
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({
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
