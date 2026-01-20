import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helpers/app_spaces.dart';
import '../../../../../core/styles/styles.dart';

class RoleOption extends StatelessWidget {
  const RoleOption({
    super.key,
    required this.roleOptionText,
    required this.roleImage,
    this.onTap,
    required this.roleDescription,
  });
  final String roleOptionText, roleImage, roleDescription;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 80.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue),
        ),
        child: Row(
          children: [
            Center(
                child: Image(
                    image: AssetImage(
                      roleImage,
                    ),
                    height: 35)),
            horizontalSpace(20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roleOptionText,
                  style: AppStylesManger.font14regularWhite.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: const Color.fromARGB(255, 19, 53, 81)),
                ),
                verticalSpace(2),
                Text(
                  roleDescription,
                  style: AppStylesManger.font14regularWhite
                      .copyWith(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
