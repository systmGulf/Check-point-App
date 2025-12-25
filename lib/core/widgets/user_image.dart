import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:profile_view/profile_view.dart';

class UserImage extends StatelessWidget {
  const UserImage({super.key, this.imageUrl, this.height});
  final String? imageUrl;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 80,
      width: height ?? 80,
      child: CircleAvatar(
        radius: 44,
        backgroundColor: ColorsManger.primaryColor,
        child: CircleAvatar(
          backgroundColor: ColorsManger.lightGreen,
          radius: 43,
          child: imageUrl != null
              ? ProfileView(
                  loadingIndicatorColor: ColorsManger.primaryColor,
                  fullscreenOnEnlarge: false,
                  enableZoom: true,
                isCircular: true ,
                        overlayBackgroundColor: ColorsManger.primaryColor ,
               badgeColor: ColorsManger.lightGreen ,
                  badgeBorderColor: ColorsManger.lightGreen,
                  placeholder: CircleAvatar(
                          radius: 20.r,
                          backgroundColor: ColorsManger.primaryColor.withOpacity(0.5),
                        child: Image.asset('assets/images/employee_image.png', height: 15.h, width: 15.w,),
                        ),
                 
                  borderColor: ColorsManger.lightGreen,
                  errorWidget:CircleAvatar(
                          radius: 20.r,
                          backgroundColor: ColorsManger.primaryColor.withOpacity(0.5),
                        child: Image.asset('assets/images/employee_image.png', height: 15.h, width: 15.w,),
                        ),
                  image: NetworkImage("http://emsdemo.runasp.net$imageUrl"),
                )
              : CircleAvatar(
                          radius: 20.r,
                          backgroundColor: ColorsManger.primaryColor.withOpacity(0.5),
                        child: Image.asset('assets/images/employee_image.png', height: 15.h, width: 15.w,),
                        ),
        ),
      ),
    );
  }
}
