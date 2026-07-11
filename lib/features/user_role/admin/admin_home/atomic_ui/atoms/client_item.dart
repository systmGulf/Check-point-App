import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/common/app_container_decoration.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/enums/customer_type.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/app_action_icon_button.dart';
import '../../../../../../core/widgets/build_alart_message.dart';
import '../../controllers/customer_cubit/customer_cubit.dart';

class ClientItem extends StatelessWidget {
  const ClientItem({
    super.key,
    required this.name,
    required this.workedAs,
    required this.location,
    required this.id,
    required this.color,
    required this.onTap,
    required this.onEdit,
  });
  final String name, workedAs, location, id;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      decoration: AppContainerDecoration(),
      child: ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
          leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade100,
              child: Icon(Icons.person, color: ColorsManger.darkblue)),
          title: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(workedAs,
                  style: AppStylesManger.font12RegularBlack
                      .copyWith(color: ColorsManger.lightblack)),
              verticalSpace(4.0),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16.0,
                    color: Colors.grey.shade600,
                  ),
                  horizontalSpace(4.0),
                  Text(
                    location,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                ],
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
                      title: 'Delete Client'.tr(context: context),
                      message: 'Are you sure you want to delete this client?'
                          .tr(context: context), onYes: () {
                    context.pop();
                    BlocProvider.of<CustomerCubit>(context).deleteCustomer(
                        customerType: CustomerType.Customer, id: id);
                  });
                },
                size: 34,
              ),
            ],
          )),
    );
  }
}
