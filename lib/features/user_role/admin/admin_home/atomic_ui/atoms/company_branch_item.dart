import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/common/app_container_decoration.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/widgets/app_action_icon_button.dart';

class CompanyBranchItem extends StatelessWidget {
  const CompanyBranchItem({
    super.key,
    required this.name,
    required this.location,
    required this.decoration,
    required this.onDelete,
  });
  final String name, location, decoration;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: AppContainerDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: ColorsManger.primaryColor,
            ),
            horizontalSpace(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  verticalSpace(5),
                  Text(
                    location,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  verticalSpace(5),
                  Text(
                    decoration,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            AppActionIconButton.delete(onPressed: onDelete, size: 34),
          ],
        ),
      ),
    );
  }
}
