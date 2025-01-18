import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/enums/customer_type.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/build_alart_message.dart';
import '../../controllers/customer_cubit/customer_cubit.dart';

class ClientItem extends StatelessWidget {
  const ClientItem({
    super.key,
    required this.name,
    required this.workedAs,
    required this.location,
    required this.id, required this.color,
  });
  final String name, workedAs, location, id;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.orange.shade100,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
      elevation:0,
      color:color ,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        side: BorderSide(color: Colors.grey),
      ),
      child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade100,
              child: Icon(Icons.person)),
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
                workedAs,
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
          trailing: IconButton(
            onPressed: () {
              buildAlertDialog(context,
                  title: 'Delete Client'.tr(context: context),
                  message: 'Are you sure you want to delete this client?'
                      .tr(context: context), onYes: () {
                context.pop();
                BlocProvider.of<CustomerCubit>(context).deleteCustomer(
                    customerType: CustomerType.Customer, id: id);
              });
            },
            icon: SizedBox(
                height: 24,
                width: 24,
                child: Center(
                    child: SvgPicture.asset('assets/images/delete_icon.svg'))),
          )),
    );
  }
}
