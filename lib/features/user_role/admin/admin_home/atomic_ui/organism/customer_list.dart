import 'package:animate_do/animate_do.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/admin_infrastructure/admin_data.dart';

import '../../../../../../core/enums/customer_type.dart';
import '../atoms/client_item.dart';

class ClientList extends StatelessWidget {
  final CustomerValue customerData;
  final Set<String> selectedClients;
  final Function(String) onToggleSelection;

  const ClientList({
    Key? key,
    required this.customerData,
    required this.selectedClients,
    required this.onToggleSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clients = customerData.data!
        .where((c) => c.customerType == CustomerType.Customer.name)
        .toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final client = clients[index];
          return GestureDetector(
            onLongPress: () => onToggleSelection(client.id!),
            onTap: () {
              if (selectedClients.contains(client.id)) {
                onToggleSelection(client.id!);
              } else {
                if (selectedClients.isNotEmpty) {
                  onToggleSelection(client.id!);
                } else {}
              }
            },
            child: FadeInUp(
              child: ClientItem(
                onTap: () {
                  context.pushName(Routes.ClientDetailsScreen);
                },
                color: selectedClients.contains(client.id)
                    ? Colors.grey.shade300
                    : Colors.white,
                id: client.id!,
                name: client.name!,
                workedAs: client.workesAs!,
                location: client.location!,
              ),
            ),
          );
        },
        childCount: clients.length,
      ),
    );
  }
}
