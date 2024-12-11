import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';

class AdminNotificationItem extends StatelessWidget {
  const AdminNotificationItem({
    super.key,
    required this.name,
    required this.mobileId, required this.onTap,
  });
  final String name, mobileId;
 final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add New User Request'.tr(context: context),
                    style: AppStylesManger.font14RegularBlack),
                Text(
                  "${"Name".tr(context: context)} : $name ",
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "${"Mobile Id".tr(context: context)} : $mobileId",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[700],
                  ),
                ),
                verticalSpace(10),
                MaterialButton(
                    color: Colors.orange,
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      'Add'.tr(context: context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    onPressed:onTap )
              ],
            ),
            const Icon(
              Icons.notifications_active,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
