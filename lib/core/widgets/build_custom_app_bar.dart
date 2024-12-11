import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

AppBar buildCustomAppBar(BuildContext context, String title,
    [List<Widget>? action]) {
  final currentLocale = EasyLocalization.of(context)!.locale;
  final currentLanguageCode = currentLocale.languageCode;
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
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
        Navigator.pop(context);
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
