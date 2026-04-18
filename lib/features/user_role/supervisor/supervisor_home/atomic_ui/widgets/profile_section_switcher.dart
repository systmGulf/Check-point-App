import 'package:flutter/material.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class ProfileSectionSwitcher extends StatelessWidget {
  const ProfileSectionSwitcher({
    super.key,
    required this.sections,
    required this.selectedIndex,
    required this.onSectionTap,
  });

  final List<String> sections;
  final int selectedIndex;
  final ValueChanged<int> onSectionTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(sections.length, (index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => onSectionTap(index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? ColorsManger.primaryColor
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  sections[index],
                  style: isSelected
                      ? AppStylesManger.font14BoldBlack
                          .copyWith(color: ColorsManger.primaryColor)
                      : AppStylesManger.font14RegularBlack,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
