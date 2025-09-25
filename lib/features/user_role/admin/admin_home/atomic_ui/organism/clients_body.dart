import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/enums/customer_type.dart';
import 'package:employee_mangement/core/widgets/build_snake_bar.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/customer_cubit/customer_cubit.dart';
import 'package:excel/excel.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import '../../../../../../core/widgets/error_widget.dart';
import '../molecules/clients_body.dart';
import '../molecules/customer_loading_widget.dart';

class ClientsBodyScreen extends StatefulWidget {
  const ClientsBodyScreen({Key? key}) : super(key: key);

  @override
  State<ClientsBodyScreen> createState() => _ClientsBodyScreenState();
}

class _ClientsBodyScreenState extends State<ClientsBodyScreen> {
  List<Map<String, dynamic>> _excelData = [];
  bool isLoading = false;
  double loadingProgress = 0.0;
  Set<String> selectedClients = {};

  Future<void> pickAndParseExcel() async {
    setLoadingState(true);
    try {
      // final result = await FilePicker.platform.pickFiles(
      //   type: FileType.custom,
      //   allowedExtensions: ['xlsx'],
      // );

      // if (result != null) {
      //   final file = File(result.files.single.path!);
      //   await parseExcelFile(file);
      // } else {
      //   showErrorSnackbar("No file selected".tr());
      // }
    } catch (e) {
      showErrorSnackbar(e.toString());
    } finally {
      setLoadingState(false);
    }
  }

  Future<void> parseExcelFile(File file) async {
    final bytes = file.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final parsedData = <Map<String, dynamic>>[];

    for (var table in excel.tables.keys) {
      final sheet = excel.tables[table];
      if (sheet != null) {
        for (var rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
          final row = sheet.rows[rowIndex];
          parsedData.add({
            "customer_name": row[0]?.value?.toString() ?? "",
            "works_as": row[1]?.value?.toString() ?? "",
            "location_in_map": row[2]?.value?.toString() ?? "",
            "location": row[3]?.value?.toString() ?? "",
          });
        }
      }
    }

    setState(() => _excelData = parsedData);

    for (var item in _excelData) {
      context.read<CustomerCubit>()
        ..nameController.text = item['customer_name']!
        ..workedAsController.text = item['works_as']!
        ..locationController.text = item['location']!
        ..addCustomer(customerType: CustomerType.Customer);
    }
  }

  void toggleSelection(String clientId) {
    setState(() {
      selectedClients.contains(clientId)
          ? selectedClients.remove(clientId)
          : selectedClients.add(clientId);
    });
  }

  Future<void> deleteSelectedClients() async {
    for (final clientId in selectedClients) {
      context.read<CustomerCubit>().deleteCustomer(
            id: clientId,
            customerType: CustomerType.Customer,
          );
    }
    setState(() => selectedClients.clear());
    showSuccessSnackbar("Clients deleted".tr());
  }

  void setLoadingState(bool value) {
    setState(() => isLoading = value);
  }

  void showErrorSnackbar(String message) {
    buildSnackBar(
      context,
      customSnackBar: CustomSnackBar.error(message: message),
    );
  }

  void showSuccessSnackbar(String message) {
    buildSnackBar(
      context,
      customSnackBar: CustomSnackBar.success(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerCubit, CustomerState>(
      buildWhen: (previous, current) =>
          current is GetAllCustomersSuccess ||
          current is GetAllCustomersError ||
          current is GetAllCustomersLoading,
      builder: (context, state) {
        if (state is GetAllCustomersSuccess) {
          return ClientsBody(
            customerData: state.customers,
            selectedClients: selectedClients,
            isLoading: isLoading,
            onPickExcel: pickAndParseExcel,
            onDeleteSelected: deleteSelectedClients,
            onToggleSelection: toggleSelection,
          );
        } else if (state is GetAllCustomersLoading) {
          return CustomerLoadingSkeleton(onPickExcel: pickAndParseExcel);
        } else if (state is GetAllCustomersError) {
          return CustomErrorWidget(
            error: state.error,
            onRetry: () => context.read<CustomerCubit>().getCustomersByType(
                  customerType: CustomerType.Customer,
                  isLoading: true,
                ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}


