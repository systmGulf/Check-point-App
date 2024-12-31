import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<String?> DeleteOrEditDialog(BuildContext context, RelativeRect position,
    void Function() onEdit, void Function() onDelete) {
  return showMenu(
    color: Colors.white,
    context: context,
    position: position,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    items: [
      PopupMenuItem(
        value: 'Edit',
        onTap: onEdit,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assign Task'.tr(context: context),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      PopupMenuItem(
        onTap: onDelete,
        value: 'Delete',
        child: const Text(
          'Delete',
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
          ),
        ),
      ),
    ],
  );
}
