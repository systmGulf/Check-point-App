import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/styles/styles.dart';

class CheckingHomeContainer extends StatelessWidget {
  const CheckingHomeContainer({
    super.key,
    required this.image,
    required this.string,
    required this.color, required this.iconColor,
  });
  final String image, string;
  final Color color, iconColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        height: 152.h,
        width: 152.h,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 10),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment: AlignmentDirectional.center,
                child: Image.asset(
                  height: 80.h,
                  color: iconColor,
                  image,
                )),
            Text(string, style: AppStylesManger.font24boldWhite),
          ],
        ),
      ),
    );
  }
}
