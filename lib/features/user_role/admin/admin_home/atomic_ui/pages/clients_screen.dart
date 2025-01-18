import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/customer_cubit/customer_cubit.dart';
import '../organism/add_client_bottom_sheet.dart';
import '../organism/clients_body.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(text: 'Add Client'.tr(context: context), onTap: (){ showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext cnx) {
              return BlocProvider.value(
                value: context.read<CustomerCubit>(),
                child: const AddClientBottomSheet(),
              );
            },
          );}),
      body: const ClientsBodyScreen(),
    );
  }
}
