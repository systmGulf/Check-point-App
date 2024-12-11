import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';

class CustomCheckingScreenAppBar extends StatelessWidget {
  const CustomCheckingScreenAppBar({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {     final currentLocale = EasyLocalization.of(context)!.locale;
    final currentLanguageCode = currentLocale.languageCode;
    return Padding(
      padding: EdgeInsetsDirectional.only(
          start: 15.w, end: 15.w, top: 10.h, bottom: 10.h),
      child: SafeArea(
        child: Row(children: [
          GestureDetector(
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
          horizontalSpace(10),
          Text(
            text,
            style: AppStylesManger.font20semiBoldBlack,
          ),
          horizontalSpace(10),
          const Icon(
            Icons.my_location_sharp,
            color: Colors.blue,
          )
        ]),
      ),
    );
  }
}
