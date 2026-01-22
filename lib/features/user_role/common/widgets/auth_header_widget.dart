import 'package:flutter/material.dart';

import '../../../../../core/animations/animations.dart';
import '../../../../../core/styles/styles.dart';
import '../constants/auth_animation_constants.dart';

class AuthHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeaderWidget({
    required this.title,
    required this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedTextWidget(
          text: title,
          style: AppStylesManger.font24regularBlack
              .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.start,
          delayDuration: AuthAnimationConstants.headerDelay,
        ),
        SizedBox(height: AuthAnimationConstants.verticalSpaceSmall),
        AnimatedTextWidget(
          text: subtitle,
          style: AppStylesManger.font14RegularBlack
              .copyWith(color: Colors.grey, fontSize: 14),
          textAlign: TextAlign.start,
          delayDuration: AuthAnimationConstants.subtitleDelay,
        ),
      ],
    );
  }
}
