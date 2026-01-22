import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/atoms/taks_card.dart';
import 'package:flutter/material.dart';

import 'animated_widget.dart';
import 'base_animation.dart';

class AnimatedButtonWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final EdgeInsets padding;
  final Duration? delayDuration;

  const AnimatedButtonWidget({
    required this.child,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    this.delayDuration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedByWidgetType(
      widgetType: WidgetAnimationType.button,
      delayDuration: delayDuration,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
      ),
    );
  }
}

class AnimatedCardWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Duration? delayDuration;
  final double elevation;
  final BorderRadius borderRadius;

  const AnimatedCardWidget({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor = Colors.white,
    this.delayDuration,
    this.elevation = 2,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedByWidgetType(
      widgetType: WidgetAnimationType.card,
      delayDuration: delayDuration,
      child: Container(
        decoration: AppConatinerDecoration(),
        color: backgroundColor,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class AnimatedTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final Duration? delayDuration;

  const AnimatedTextWidget({
    required this.text,
    this.style,
    this.textAlign = TextAlign.center,
    this.delayDuration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedByWidgetType(
      widgetType: WidgetAnimationType.text,
      delayDuration: delayDuration,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}

class AnimatedImageWidget extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final BoxFit fit;
  final Duration? delayDuration;

  const AnimatedImageWidget({
    required this.imagePath,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.delayDuration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedByWidgetType(
      widgetType: WidgetAnimationType.image,
      delayDuration: delayDuration,
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}

class AnimatedIconWidget extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final Duration? delayDuration;

  const AnimatedIconWidget({
    required this.icon,
    this.size = 24,
    this.color = Colors.blue,
    this.delayDuration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedByWidgetType(
      widgetType: WidgetAnimationType.icon,
      delayDuration: delayDuration,
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
    );
  }
}

class AnimatedContainerWidget extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Duration? delayDuration;

  const AnimatedContainerWidget({
    required this.child,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.delayDuration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedByWidgetType(
      widgetType: WidgetAnimationType.container,
      delayDuration: delayDuration,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}

class AnimatedDialogWidget extends StatelessWidget {
  final Widget child;
  final Duration? delayDuration;

  const AnimatedDialogWidget({
    required this.child,
    this.delayDuration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedByWidgetType(
      widgetType: WidgetAnimationType.dialog,
      delayDuration: delayDuration,
      child: child,
    );
  }
}

class AnimatedListItemWidget extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration? customStaggerInterval;

  const AnimatedListItemWidget({
    required this.child,
    required this.index,
    this.customStaggerInterval,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedByWidgetType(
      widgetType: WidgetAnimationType.listItem,
      listIndex: index,
      child: child,
    );
  }
}

class AnimatedHeaderWidget extends StatelessWidget {
  final Widget child;
  final Duration? delayDuration;

  const AnimatedHeaderWidget({
    required this.child,
    this.delayDuration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedByWidgetType(
      widgetType: WidgetAnimationType.header,
      delayDuration: delayDuration,
      child: child,
    );
  }
}
