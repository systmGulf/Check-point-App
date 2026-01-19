import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/styles/styles.dart';

class CheckingHomeContainer extends StatelessWidget {
  const CheckingHomeContainer({
    super.key,
    required this.image,
    required this.string,
    required this.color,
    required this.iconColor,
    required this.time,
  });
  final String image, string;
  final Color color, iconColor;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        height: 152.h,
        width: 152.h,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment: AlignmentDirectional.center,
                child: Image.asset(
                  height: 50.h,
                  color: iconColor,
                  image,
                )),
            Text(string,
                style: AppStylesManger.font15BoldBlack
                    .copyWith(color: Colors.black)),
            Text(time,
                style: AppStylesManger.font12RegularGrey
                    .copyWith(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
