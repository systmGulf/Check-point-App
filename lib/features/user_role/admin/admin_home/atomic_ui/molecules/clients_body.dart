import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/admin_infrastructure/data/models/customers_model/get_customer_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../../core/enums/customer_type.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/app_action_icon_button.dart';
import '../../controllers/customer_cubit/customer_cubit.dart';
import '../organism/customer_list.dart';
import 'custom_admin_app_bar.dart';

class ClientsBody extends StatelessWidget {
  final CustomerValue customerData;
  final Set<String> selectedClients;
  final bool isLoading;
  final VoidCallback onPickExcel;
  final VoidCallback onDeleteSelected;
  final Function(String) onToggleSelection;

  const ClientsBody({
    Key? key,
    required this.customerData,
    required this.selectedClients,
    required this.isLoading,
    required this.onPickExcel,
    required this.onDeleteSelected,
    required this.onToggleSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: CircularProgressIndicator(
        color: ColorsManger.primaryColor,
        strokeWidth: 2,
      ),
      child: Stack(
        children: [
          RefreshIndicator(
            color: ColorsManger.primaryColor,
            onRefresh: () async {
              context.read<CustomerCubit>().getCustomersByType(
                    customerType: CustomerType.Customer,
                    isLoading: true,
                  );
            },
            child: CustomScrollView(
              slivers: [
                CustomAdminAppBar(
                    onPickExcel: onPickExcel, appBarName: 'Clients'),
                ClientList(
                  customerData: customerData,
                  selectedClients: selectedClients,
                  onToggleSelection: onToggleSelection,
                ),
              ],
            ),
          ),
          if (selectedClients.isNotEmpty)
            Positioned(
              top: 95,
              right: 16,
              child: FloatingActionButton(
                onPressed: onDeleteSelected,
                backgroundColor: Colors.red,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppActionIconButton.delete(
                      onPressed: onDeleteSelected,
                      size: 30,
                      backgroundColor: Colors.transparent,
                      iconColor: Colors.white,
                    ),
                    Text(
                      selectedClients.length.toString(),
                      style: AppStylesManger.font16BoldWhite,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
