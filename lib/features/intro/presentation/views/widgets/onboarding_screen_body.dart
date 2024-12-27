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
        Image.asset('assets/images/banner-my-course.png'),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: TextButton(
                        onPressed: () {
                          buildChangeLanguageBottomSheet(context);
                        },
                        child: const SizedBox(
                          width: 30,
                          child: Image(
                              image: AssetImage(
                                  'assets/images/icon-language.png')),
                        )),
                  ),
                  const Spacer(),
                  const Image(
                    image: AssetImage('assets/images/app_logo.png'),
                  ),
                  verticalSpace(30),
                  CustomAppButton(
                    onPressed: () {
                      context.pushName(Routes.userRoleScreen);
                    },
                    textButton: 'get_started'.tr(),
                    buttonColor: ColorsManger.primaryColor,
                  ),
                  const Spacer(),
                  TextButton(
                    child: Text.rich(TextSpan(
                      text: 'Ask Admin to Create Account  '.tr(),
                      children: [
                        TextSpan(
                            text: 'register'.tr(),
                            style: AppStylesManger.font16BoldBlack
                                .copyWith(color: ColorsManger.primaryColor)),
                      ],
                    )),
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) {
                            return BlocProvider.value(
                              value: context.read<RegisterAccountCubit>(),
                              child: const RegisterAccountDialog(),
                            );
                          });
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const RegisterAccountBlocListener()
                ],
              ),
            )),
      ],
    );
  }
}
