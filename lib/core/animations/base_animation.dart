import 'package:flutter/material.dart';

enum AnimationType {
  fadeIn,
  slideInLeft,
  slideInRight,
  slideInUp,
  slideInDown,
  scaleIn,
  bounceIn,
  elasticInUp,
  elasticInDown,
  rotation,
  custom,
}

class BaseAnimation {
  final AnimationType type;
  final Duration duration;
  final Curve curve;
  final bool repeat;
  final double? delay;

  const BaseAnimation({
    required this.type,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.repeat = false,
    this.delay,
  });

  static const BaseAnimation fadeInAnimation = BaseAnimation(
    type: AnimationType.fadeIn,
    duration: Duration(milliseconds: 500),
  );

  static const BaseAnimation slideInLeftAnimation = BaseAnimation(
    type: AnimationType.slideInLeft,
    duration: Duration(milliseconds: 600),
  );

  static const BaseAnimation slideInRightAnimation = BaseAnimation(
    type: AnimationType.slideInRight,
    duration: Duration(milliseconds: 600),
  );

  static const BaseAnimation slideInUpAnimation = BaseAnimation(
    type: AnimationType.slideInUp,
    duration: Duration(milliseconds: 600),
  );

  static const BaseAnimation slideInDownAnimation = BaseAnimation(
    type: AnimationType.slideInDown,
    duration: Duration(milliseconds: 600),
  );

  static const BaseAnimation scaleInAnimation = BaseAnimation(
    type: AnimationType.scaleIn,
    duration: Duration(milliseconds: 500),
  );

  static const BaseAnimation bounceInAnimation = BaseAnimation(
    type: AnimationType.bounceIn,
    duration: Duration(milliseconds: 700),
  );

  static const BaseAnimation elasticInUpAnimation = BaseAnimation(
    type: AnimationType.elasticInUp,
    duration: Duration(milliseconds: 600),
  );

  static const BaseAnimation elasticInDownAnimation = BaseAnimation(
    type: AnimationType.elasticInDown,
    duration: Duration(milliseconds: 600),
  );

  static const BaseAnimation rotationAnimation = BaseAnimation(
    type: AnimationType.rotation,
    duration: Duration(milliseconds: 800),
  );
}

enum WidgetAnimationType {
  button,
  card,
  text,
  image,
  icon,
  container,
  dialog,
  listItem,
  header,
  custom,
}

class AnimationByWidgetType {
  static BaseAnimation getAnimation(WidgetAnimationType type) {
    switch (type) {
      case WidgetAnimationType.button:
        return BaseAnimation.scaleInAnimation;
      case WidgetAnimationType.card:
        return BaseAnimation.slideInUpAnimation;
      case WidgetAnimationType.text:
        return BaseAnimation.fadeInAnimation;
      case WidgetAnimationType.image:
        return BaseAnimation.fadeInAnimation;
      case WidgetAnimationType.icon:
        return BaseAnimation.bounceInAnimation;
      case WidgetAnimationType.container:
        return BaseAnimation.slideInLeftAnimation;
      case WidgetAnimationType.dialog:
        return BaseAnimation.elasticInUpAnimation;
      case WidgetAnimationType.listItem:
        return BaseAnimation.slideInLeftAnimation;
      case WidgetAnimationType.header:
        return BaseAnimation.slideInDownAnimation;
      case WidgetAnimationType.custom:
        return BaseAnimation.fadeInAnimation;
    }
  }

  static Duration getStaggerDelay(int index) {
    return Duration(milliseconds: 100 * (index + 1));
  }
}
