import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

AppBar buildCustomAppBar(BuildContext context, String title,
    [List<Widget>? action]) {
  final currentLocale = EasyLocalization.of(context)!.locale;
  final currentLanguageCode = currentLocale.languageCode;
  DateTime? _lastBackPressTime;
  return AppBar(
    elevation: 0,
    backgroundColor: ColorsManger.scaffoldBackgroundColor,
    surfaceTintColor: Colors.transparent,
    actions: action,
    shadowColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    foregroundColor: const Color(0xFF24252C),
    title: SizedBox(
      width: 299,
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF24252C),
          fontSize: 16,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w700,
          height: 0.09,
        ),
      ),
    ),
    leading: GestureDetector(
      onTap: () {
        if (Navigator.canPop(context)) {
          context.pop();
        } else {
          final now = DateTime.now();

          if (_lastBackPressTime == null ||
              now.difference(_lastBackPressTime!) >
                  const Duration(seconds: 2)) {
            _lastBackPressTime = now;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Press again to exit'.tr(context: context)),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: SizedBox(
        height: 24,
        width: 24,
        child: Center(
          child: Transform(
              alignment: Alignment.center,
              transform: currentLanguageCode == 'ar'
                  ? Matrix4.rotationY(3.14)
                  : Matrix4.rotationY(0),
              child: SvgPicture.asset('assets/images/arrow_back.svg')),
        ),
      ),
    ),
  );
}
