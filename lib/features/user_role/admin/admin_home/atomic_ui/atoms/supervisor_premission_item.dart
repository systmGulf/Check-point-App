import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

class SupervisorPermissionItem extends StatefulWidget {
  const SupervisorPermissionItem({
    required this.text,
    required this.icon,
    required this.iconColor,
    required this.isChecked,
    required this.onChanged,
    super.key,
  });
  final String text;
  final IconData icon;
  final Color iconColor;
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  @override
  State<SupervisorPermissionItem> createState() =>
      _SupervisorPermissionItemState();
}

class _SupervisorPermissionItemState extends State<SupervisorPermissionItem> {
  @override
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        widget.icon,
        color: widget.iconColor,
      ),
      title: Text(widget.text, style: AppStylesManger.font14RegularBlack),
      trailing: AdvancedSwitch(
        initialValue: widget.isChecked,
        onChanged: (value) {
          widget.onChanged(value as bool);
        },
        activeColor: ColorsManger.primaryColor,
      ),
    );
  }
}
