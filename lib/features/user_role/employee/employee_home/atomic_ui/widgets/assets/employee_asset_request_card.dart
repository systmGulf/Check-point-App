import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_asset_status_mapper.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assets_model/employee_asset_requests_response.dart';

class EmployeeAssetRequestCard extends StatelessWidget {
  const EmployeeAssetRequestCard({
    super.key,
    required this.request,
  });

  final EmployeeAssetRequestItem request;

  @override
  Widget build(BuildContext context) {
    final label = EmployeeAssetStatusMapper.label(request.status);
    final color = EmployeeAssetStatusMapper.color(request.status);
    final backgroundColor =
        EmployeeAssetStatusMapper.backgroundColor(request.status);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.assetName?.trim().isNotEmpty == true
                      ? request.assetName!
                      : 'Asset request',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            request.requestNotes?.trim().isNotEmpty == true
                ? request.requestNotes!
                : 'No note provided',
            style: const TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Requested at: ${formatDateValue(request.requestedAt)}',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

String formatDateValue(String? value) {
  if (value == null || value.trim().isEmpty) return '-';
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return value;
  return '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
}
