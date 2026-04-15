import 'package:employee_mangement/core/styles/styles.dart';
import 'package:flutter/material.dart';

class CustomFilterRequestButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback? onTap;
  final Color? buttonColor;
  final Color? textColor;
  const CustomFilterRequestButton({
    super.key,
    required this.buttonTitle,
    this.onTap,
    this.buttonColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor ?? Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          buttonTitle,
          style: AppStylesManger.font14BoldBlack.copyWith(color: textColor),
        ),
      ),
    );
  }
}
