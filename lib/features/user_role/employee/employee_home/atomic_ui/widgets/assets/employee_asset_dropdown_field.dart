import 'package:flutter/material.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assets_model/employee_assets_response.dart';

class EmployeeAssetDropdownField extends StatelessWidget {
  const EmployeeAssetDropdownField({
    super.key,
    required this.assets,
    required this.selectedAssetId,
    required this.onChanged,
  });

  final List<EmployeeAssetItem> assets;
  final String? selectedAssetId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      initialValue: selectedAssetId,
      borderRadius: BorderRadius.circular(12),
      isExpanded: true,
      decoration: InputDecoration(
        hintText: 'Choose asset',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      items: assets
          .map(
            (asset) => DropdownMenuItem<String>(
              value: asset.id,
              child: Text(
                asset.name?.trim().isNotEmpty == true ? asset.name! : 'Asset',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
