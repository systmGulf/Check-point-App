import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/styles/styles.dart';

class CustomAdminAppBar extends StatelessWidget {
  final VoidCallback onPickExcel;
  final String appBarName;

  const CustomAdminAppBar(
      {Key? key, required this.onPickExcel, required this.appBarName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeCode = EasyLocalization.of(context)!.locale.languageCode;

    return SliverAppBar(
      floating: false,
      pinned: true,
      surfaceTintColor: Colors.transparent,
      expandedHeight: 130,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Transform(
          alignment: Alignment.center,
          transform: localeCode == 'ar'
              ? Matrix4.rotationY(3.14)
              : Matrix4.rotationY(0),
          child: Center(
              child: SvgPicture.asset('assets/images/arrow_back.svg',
                  height: 28.h)),
        ),
      ),
      actions: [
        IconButton(
          onPressed: onPickExcel,
          icon: const Icon(Icons.file_download_sharp),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          '$appBarName'.tr(),
          style: AppStylesManger.font15BoldBlack,
        ),
      ),
    );
  }
}
