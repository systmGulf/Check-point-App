import 'package:employee_mangement/core/widgets/no_interet_connextion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../helpers/app_spaces.dart';

class CustomErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const CustomErrorWidget(
      {Key? key, required this.error, required this.onRetry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (error == 'Please check your internet connection') {
      return NoInternetConnectionWidget(onPressed: onRetry);
    } else {
      return Center(
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
            Text(error,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }
  }
}
