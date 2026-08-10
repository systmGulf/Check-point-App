import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:profile_view/profile_view.dart';

class UserImage extends StatelessWidget {
  const UserImage({super.key, this.imageUrl, this.height});
  final String? imageUrl;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return SizedBox(
      height: height ?? 80,
      width: height ?? 80,
      child: CircleAvatar(
        backgroundColor: ColorsManger.primaryColor,
        child: CircleAvatar(
          backgroundColor: ColorsManger.lightGreen,
          radius: 80.r,
          child: hasImage
              ? ProfileView(
                  loadingIndicatorColor: ColorsManger.primaryColor,
                  fullscreenOnEnlarge: false,
                  enableZoom: true,
                  height: height ?? 80,
                  width: height ?? 80,
                  overlayBackgroundColor: ColorsManger.primaryColor,
                  placeholder: CircleAvatar(
                    radius: 70.r,
                    child: Lottie.asset(
                      'assets/animated_images/profile_image.json',
                      height: height ?? 80,
                      width: height ?? 80,
                    ),
                  ),
                  borderColor: ColorsManger.primaryColor,
                  errorWidget: Lottie.asset(
                    'assets/animated_images/profile_image.json',
                  ),
                  image: NetworkImage(
                    "http://emstothrms.runasp.net${imageUrl!}",
                    scale: 1.0,
                  ),
                )
              : Lottie.asset(
                  'assets/animated_images/profile_image.json',
                  height: height ?? 80,
                  width: height ?? 80,
                ),
        ),
      ),
    );
  }
}
