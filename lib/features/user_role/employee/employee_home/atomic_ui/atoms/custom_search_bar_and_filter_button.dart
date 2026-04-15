import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:employee_mangement/core/widgets/custom_app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class CustomSearchBarAndFilterButton extends StatelessWidget {
  final VoidCallback? onFilterTap;
  final TextEditingController controller;
  final String? qurey;
  final dynamic Function(String)? onChanged;
  final bool isShown;
  const CustomSearchBarAndFilterButton({
    super.key,
    this.onFilterTap,
    required this.controller,
    this.qurey,
    this.onChanged,
    this.isShown = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 9,
          child: CustomAppTextFormField(
            hint: "Search for Task",
            prefixIcon: Icon(Icons.search),
            onChanged: onChanged,
          ),
        ),
        horizontalSpace(8),
        if (isShown)
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onFilterTap,
              child: CustomAppTextFormField(
                readOnly: true,
                hint: "",
                prefixIcon: GestureDetector(
                  onTap: onFilterTap,
                  child: Center(
                    child: SvgPicture.asset(
                      Assets.assetsImagesFilter,
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
