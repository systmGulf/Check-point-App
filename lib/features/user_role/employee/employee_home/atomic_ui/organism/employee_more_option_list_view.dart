import 'package:flutter/material.dart';

import '../atoms/employee_more_options_drawer_items.dart';

class MoreOptionDrawerListView extends StatefulWidget {
  const MoreOptionDrawerListView({super.key, this.isSupervisor = false});

  final bool isSupervisor;

  @override
  State<MoreOptionDrawerListView> createState() =>
      _MoreOptionDrawerListViewState();
}

class _MoreOptionDrawerListViewState extends State<MoreOptionDrawerListView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = employeeMoreOptionsDrawerItems(
      context,
      isSupervisor: widget.isSupervisor,
    );
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return children[index];
        },
        itemCount: children.length);
  }
}
