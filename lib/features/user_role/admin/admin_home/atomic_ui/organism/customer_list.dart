import 'package:flutter/material.dart';
import 'package:hr_management_system_package/admin/admin_data.dart';

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
                } else {
                  // Navigate or perform another action.
                }
              }
            },
            child: ClientItem(
              color: selectedClients.contains(client.id)
                  ? Colors.grey.shade300
                  : Colors.white,
              id: client.id!,
              name: client.name!,
              workedAs: client.workesAs!,
              location: client.location!,
            ),
          );
        },
        childCount: clients.length,
      ),
    );
  }
}

