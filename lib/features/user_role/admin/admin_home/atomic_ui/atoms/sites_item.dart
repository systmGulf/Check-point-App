import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/common/app_container_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/enums/customer_type.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/app_action_icon_button.dart';
import '../../../../../../core/widgets/build_alart_message.dart';
import '../../controllers/customer_cubit/customer_cubit.dart';

class SitesItem extends StatelessWidget {
  const SitesItem({
    super.key,
    required this.name,
    required this.descritption,
    required this.location,
    required this.id,
    required this.onEdit,
  });
  final String name, descritption, location;
  final String id;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      decoration: AppContainerDecoration(),
      child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.orange.shade100,
              child: Image.asset('assets/images/industry.png')),
          title: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                descritption,
                style: TextStyle(
                  color: ColorsManger.primaryColor,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                location,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppActionIconButton.edit(
                onPressed: onEdit,
                size: 34,
              ),
              const SizedBox(width: 8),
              AppActionIconButton.delete(
                onPressed: () {
                  buildDeleteAlertDialog(context,
                      title: 'Delete Site'.tr(),
                      message: 'Are you sure you want to delete this Site?'
                          .tr(), onYes: () {
                    context
                        .read<CustomerCubit>()
                        .deleteCustomer(
                            id: id, customerType: CustomerType.Site);

                    context.pop();
                  });
                },
                size: 34,
              ),
            ],
          )),
    );
  }
}
