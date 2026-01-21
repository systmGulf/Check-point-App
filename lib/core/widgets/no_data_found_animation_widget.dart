import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../helpers/app_spaces.dart';
import '../styles/styles.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 40.w,
        ),
        child: Opacity(
          opacity: 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animated_images/empty.json',
                repeat: false,
                height: 150.h,
                width: 150.w,
                fit: BoxFit.cover,
              ),
              verticalSpace(10),
              Jello(
                child: Text('No Data Found'.tr(context: context),
                    style: AppStylesManger.font16BoldBlack
                        .copyWith(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
