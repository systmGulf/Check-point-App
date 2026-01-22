import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'base_animation.dart';

class AnimatedWidget extends StatelessWidget {
  final Widget child;
  final BaseAnimation animation;
  final Duration? delayDuration;

  const AnimatedWidget({
    required this.child,
    required this.animation,
    this.delayDuration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final delay =
        delayDuration ?? Duration(milliseconds: (animation.delay ?? 0).toInt());

    return _buildAnimation(delay);
  }

  Widget _buildAnimation(Duration delay) {
    switch (animation.type) {
      case AnimationType.fadeIn:
        return FadeIn(
          duration: animation.duration,
          delay: delay,
          curve: animation.curve,
          child: child,
        );
      case AnimationType.slideInLeft:
        return SlideInLeft(
          duration: animation.duration,
          delay: delay,
          curve: animation.curve,
          child: child,
        );
      case AnimationType.slideInRight:
        return SlideInRight(
          duration: animation.duration,
          delay: delay,
          curve: animation.curve,
          child: child,
        );
      case AnimationType.slideInUp:
        return SlideInUp(
          duration: animation.duration,
          delay: delay,
          curve: animation.curve,
          child: child,
        );
      case AnimationType.slideInDown:
        return SlideInDown(
          duration: animation.duration,
          delay: delay,
          curve: animation.curve,
          child: child,
        );
      case AnimationType.scaleIn:
        return ZoomIn(
          duration: animation.duration,
          delay: delay,
          curve: animation.curve,
          child: child,
        );
      case AnimationType.bounceIn:
        return BounceInUp(
          duration: animation.duration,
          delay: delay,
          curve: animation.curve,
          child: child,
        );
      case AnimationType.elasticInUp:
        return ElasticInUp(
          duration: animation.duration,
          delay: delay,
          curve: animation.curve,
          child: child,
        );
      case AnimationType.elasticInDown:
        return ElasticInDown(
          duration: animation.duration,
          delay: delay,
          curve: animation.curve,
          child: child,
        );
      case AnimationType.rotation:
        return Spin(
          duration: animation.duration,
          delay: delay,
          curve: animation.curve,
          child: child,
        );
      case AnimationType.custom:
        return child;
    }
  }
}

class StaggeredAnimationList extends StatelessWidget {
  final List<Widget> children;
  final BaseAnimation animation;
  final Duration staggerInterval;

  const StaggeredAnimationList({
    required this.children,
    required this.animation,
    this.staggerInterval = const Duration(milliseconds: 100),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return AnimatedWidget(
          animation: animation,
          delayDuration: staggerInterval * index,
          child: children[index],
        );
      },
    );
  }
}

class AnimatedByWidgetType extends StatelessWidget {
  final Widget child;
  final WidgetAnimationType widgetType;
  final Duration? delayDuration;
  final int? listIndex;

  const AnimatedByWidgetType({
    required this.child,
    required this.widgetType,
    this.delayDuration,
    this.listIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animation = AnimationByWidgetType.getAnimation(widgetType);

    Duration finalDelay = delayDuration ?? Duration.zero;
    if (listIndex != null) {
      finalDelay = AnimationByWidgetType.getStaggerDelay(listIndex!);
    }

    return AnimatedWidget(
      animation: animation,
      delayDuration: finalDelay,
      child: child,
    );
  }
}
