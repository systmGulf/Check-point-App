import 'package:flutter/material.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assets_model/employee_assets_response.dart';

class EmployeeAssetSelectableCard extends StatelessWidget {
  const EmployeeAssetSelectableCard({
    super.key,
    required this.asset,
    required this.isSelected,
    required this.onTap,
  });

  final EmployeeAssetItem asset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF6366F1) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    asset.name?.trim().isNotEmpty == true
                        ? asset.name!
                        : 'Asset',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: isSelected
                      ? const Color(0xFF4F46E5)
                      : const Color(0xFF9CA3AF),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              asset.description?.trim().isNotEmpty == true
                  ? asset.description!
                  : 'No description',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF4B5563),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Category: ${asset.category?.trim().isNotEmpty == true ? asset.category : '-'}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
