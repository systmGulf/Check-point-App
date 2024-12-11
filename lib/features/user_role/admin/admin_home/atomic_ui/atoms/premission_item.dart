import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/styles/styles.dart';

class ManagementScreenGridViewItem extends StatelessWidget {
  const ManagementScreenGridViewItem({
    super.key,
    required this.text,
    required this.color1,
    required this.color2,
    this.onTap,
    required this.image,
  });
  final String text, image;
  final Color color1, color2;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x29000000),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 10),
                    height: 45.h,
                    width: 45.w,
                    decoration: BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(image, height: 10.h, width: 10.w),
                  ),
                  const Spacer(),
                  Center(
                    child: Text(text,
                        style: AppStylesManger.font15BoldBlack
                            .copyWith(fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 5,
            decoration: BoxDecoration(
              color: color1,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
