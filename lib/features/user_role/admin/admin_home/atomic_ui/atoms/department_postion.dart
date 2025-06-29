import 'package:flutter/material.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class DepartmentPosition extends StatelessWidget {
  const DepartmentPosition({
    super.key,
    required this.text,
    required this.index,
    this.onTap,
  });
  final String text;
  final bool index;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: index == true ? ColorsManger.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          width: 100,
          child: Center(
            child: Text(
              text,
              style: index == true
                  ? AppStylesManger.font14regularWhite
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 16)
                  : AppStylesManger.font14RegularBlack.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
