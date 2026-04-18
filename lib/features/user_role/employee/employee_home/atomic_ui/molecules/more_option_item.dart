import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class MoreOptionDrawerItem extends StatelessWidget {
  const MoreOptionDrawerItem({super.key, this.children, required this.title});
  final List<Widget>? children;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ColorsManger.borderColor),
        ),
        child: ExpansionTileGroup(children: [
          ExpansionTileItem(
            tilePadding: const EdgeInsets.symmetric(horizontal: 14),
            childrenPadding: const EdgeInsets.only(bottom: 8),
            title: Text(
              title,
              style: AppStylesManger.font16BoldBlack,
            ),
            children: children,
          ),
        ]),
      ),
    );
  }
}
