import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/styles/styles.dart';

class MoreOptionDrawerItem extends StatelessWidget {
  const MoreOptionDrawerItem({super.key, this.children, required this.title});
  final List<Widget>? children;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ExpansionTileGroup(children: [
      ExpansionTileItem(
          title: Text(
          title,
            style: AppStylesManger.font18RegulerBlack,
          ),
          children: children),
    ]);
  }
}
