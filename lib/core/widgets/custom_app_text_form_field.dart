import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/styles.dart';

class CustomAppTextFormField extends StatelessWidget {
  const CustomAppTextFormField({
    super.key,
    required this.hint,
    this.icon,
    this.obscureText,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.maxLines,
    this.readOnly,
    this.onTap,
    this.onChanged, this.prefixIcon, this.hintStyle, this.autofillHints, this.keyboardType,
  });
  final String hint;
  final IconData? icon;
  final void Function()? onTap;
  final bool? obscureText;
  final Widget? suffixIcon, prefixIcon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final int? maxLines;
  final TextStyle? hintStyle;
  final bool? readOnly;
  final Function(String)? onChanged;
  final Iterable<String>? autofillHints;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints:autofillHints ,
      cursorColor: ColorsManger.primaryColor,
      onTap: onTap,
      readOnly: readOnly ?? false,
      onChanged: onChanged,
      keyboardType:  keyboardType,
      
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: obscureText ?? false,
      
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              gapPadding: 0,
              borderSide: BorderSide(color: Color(0XFFD9D9D9)),
              borderRadius: BorderRadius.all(Radius.circular(16))),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
              gapPadding: 0,
              borderSide: BorderSide(color: ColorsManger.primaryColor),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          focusedBorder: OutlineInputBorder(
              gapPadding: 5,
              borderSide: BorderSide(color: ColorsManger.primaryColor),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          hintStyle: hintStyle ?? AppStylesManger.font15regulerGrey,
          fillColor: Colors.white,
          filled: true,
          prefixIcon: prefixIcon  ,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          hintText: hint),
    );
  }
}
