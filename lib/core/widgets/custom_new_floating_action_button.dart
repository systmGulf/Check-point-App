import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';

class CustomNewFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const CustomNewFloatingActionButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: ColorsManger.primaryColor,
      shape: const CircleBorder(),
      child: Icon(Icons.add,color: ColorsManger.white,),
      onPressed: onPressed,
    );
  }
}
