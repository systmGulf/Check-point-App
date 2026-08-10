import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppActionIconButtonType { edit, delete }

class AppActionIconButton extends StatelessWidget {
  const AppActionIconButton.edit({
    super.key,
    required this.onPressed,
    this.size = 42,
    this.backgroundColor,
    this.iconColor,
  }) : type = AppActionIconButtonType.edit;

  const AppActionIconButton.delete({
    super.key,
    required this.onPressed,
    this.size = 42,
    this.backgroundColor,
    this.iconColor,
  }) : type = AppActionIconButtonType.delete;

  const AppActionIconButton({
    super.key,
    required this.type,
    required this.onPressed,
    this.size = 42,
    this.backgroundColor,
    this.iconColor,
  });

  final AppActionIconButtonType type;
  final VoidCallback onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final isDelete = type == AppActionIconButtonType.delete;
    final Color resolvedBackgroundColor = backgroundColor ??
        (isDelete ? const Color(0xFFFFECEC) : const Color(0xFFF4F0FF));
    final Color resolvedIconColor = iconColor ??
        (isDelete ? const Color(0xFFE53935) : ColorsManger.primaryColor);
    final String asset = isDelete ? Assets.DeleteIconImage : Assets.EditImage;

    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: onPressed,
        radius: size.r,
        splashColor: resolvedIconColor.withValues(alpha: 0.12),
        highlightColor: resolvedIconColor.withValues(alpha: 0.06),
        child: Container(
          width: size.r,
          height: size.r,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: resolvedBackgroundColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: resolvedIconColor.withValues(alpha: 0.18),
            ),
          ),
          child: SvgPicture.asset(
            asset,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              resolvedIconColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
