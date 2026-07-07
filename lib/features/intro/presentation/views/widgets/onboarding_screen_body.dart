import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
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
        Positioned.fill(
          child: Image.asset(
            Assets.OnboardingBgImageImage,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.18),
                  Colors.black.withValues(alpha: 0.65),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(22.w, 16.h, 22.w, 20.h),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: SizedBox(
                    width: 118.w,
                    child: CustomAppButton(
                      height: 42.h,
                      textButton: 'language'.tr(),
                      buttonColor: ColorsManger.primaryColor,
                      onPressed: () {
                        buildChangeLanguageBottomSheet(context);
                      },
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.96),
                    borderRadius: BorderRadius.circular(32.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 28,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 64.w,
                        height: 64.w,
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color:
                              ColorsManger.primaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: AnimatedImageWidget(
                          imagePath: Assets.VodafoneImage,
                          width: 40.w,
                          height: 40.w,
                        ),
                      ),
                      verticalSpace(18),
                      AnimatedTextWidget(
                        text: 'Workforce management made simple'.tr(),
                        style: AppStylesManger.font26RegularBlack.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      verticalSpace(10),
                      AnimatedTextWidget(
                        text:
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
                            label: 'Daily attendance and task tracking'.tr(),
                          ),
                          _OnboardingInfoChip(
                            label:
                                'Team leadership and assignment control'.tr(),
                          ),
                        ],
                      ),
                      verticalSpace(24),
                      CustomAppButton(
                        onPressed: () {
                          context.pushName(Routes.userRoleScreen);
                        },
                        textButton: 'get_started'.tr(),
                        buttonColor: ColorsManger.primaryColor,
                      ),
                      verticalSpace(12),
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
                            style: AppStylesManger.font14RegularBlack,
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
                verticalSpace(10),
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
  const _OnboardingInfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: ColorsManger.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: AppStylesManger.font12RegularBlack.copyWith(
          color: ColorsManger.lightblack,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
