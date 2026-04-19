import 'package:employee_mangement/features/user_role/employee/employee_home/controller/assets/employee_assets_state.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/allowance/employee_allowance_status_mapper.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_asset_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_allowance_model/beneficiary_allowances_response.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmployeeAllowanceDashboardBody extends StatelessWidget {
  const EmployeeAllowanceDashboardBody({
    super.key,
    required this.state,
    required this.onRefresh,
  });

  final EmployeeAssetsState state;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final items = state.allowances;

    if (state.isLoadingAllowances && items.isEmpty) {
      return const _EmployeeAllowanceDashboardSkeleton();
    }

    if (state.errorMessage != null && items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 36),
              const SizedBox(height: 12),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onRefresh,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final approvedCount = items
        .where((item) =>
            EmployeeAllowanceStatusMapper.label(
              item.beneficiaryAllowanceStatus,
            ) ==
            'Approved')
        .length;
    final pendingCount = items.length - approvedCount;
    final totalAmount = items.fold<double>(
      0,
      (sum, item) => sum + (item.amount?.toDouble() ?? 0),
    );

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.5,
          children: [
            EmployeeAssetSummaryCard(
              title: 'Allowances',
              value: items.length.toString(),
              icon: Icons.account_balance_wallet_outlined,
            ),
            EmployeeAssetSummaryCard(
              title: 'Approved',
              value: approvedCount.toString(),
              icon: Icons.check_circle_outline_rounded,
            ),
            EmployeeAssetSummaryCard(
              title: 'Pending',
              value: pendingCount.toString(),
              icon: Icons.hourglass_bottom_rounded,
            ),
            EmployeeAssetSummaryCard(
              title: 'Total Amount',
              value: _formatAmount(totalAmount),
              icon: Icons.payments_outlined,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Allowance Requests',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('No allowance data'),
            ),
          )
        else
          ...List<Widget>.generate(
            items.length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 10),
              child: _EmployeeAllowanceCard(item: items[index]),
            ),
          ),
      ],
      ),
    );
  }

  String _formatAmount(double value) {
    final amount = value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
    return '$amount EGP';
  }
}

class _EmployeeAllowanceDashboardSkeleton extends StatelessWidget {
  const _EmployeeAllowanceDashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.5,
            children: List<Widget>.generate(
              4,
              (_) => const EmployeeAssetSummaryCard(
                title: 'Loading',
                value: '0000',
                icon: Icons.account_balance_wallet_outlined,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Allowance Requests',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...List<Widget>.generate(
            4,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: _AllowanceSkeletonCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AllowanceSkeletonCard extends StatelessWidget {
  const _AllowanceSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Allowance name'),
          SizedBox(height: 8),
          Text('Type: ...'),
          SizedBox(height: 6),
          Text('Beneficiary: ...'),
          SizedBox(height: 6),
          Text('Amount: ...'),
          SizedBox(height: 6),
          Text('Period: ...'),
        ],
      ),
    );
  }
}

class _EmployeeAllowanceCard extends StatelessWidget {
  const _EmployeeAllowanceCard({
    required this.item,
  });

  final BeneficiaryAllowanceItem item;

  @override
  Widget build(BuildContext context) {
    final statusLabel =
        EmployeeAllowanceStatusMapper.label(item.beneficiaryAllowanceStatus);
    final statusColor =
        EmployeeAllowanceStatusMapper.textColor(item.beneficiaryAllowanceStatus);
    final statusBg =
        EmployeeAllowanceStatusMapper.backgroundColor(item.beneficiaryAllowanceStatus);

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
                  item.allowanceName?.trim().isNotEmpty == true
                      ? item.allowanceName!
                      : 'Allowance',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _MetaLine(
            title: 'Type',
            value: item.allowanceTypeName?.trim().isNotEmpty == true
                ? item.allowanceTypeName!
                : '-',
          ),
          _MetaLine(
            title: 'Beneficiary',
            value: item.beneficiaryData?.beneficiaryName?.trim().isNotEmpty == true
                ? item.beneficiaryData!.beneficiaryName!
                : '-',
          ),
          _MetaLine(
            title: 'Amount',
            value: '${(item.amount ?? 0).toStringAsFixed(0)} EGP',
          ),
          _MetaLine(
            title: 'Period',
            value:
                '${_formatDate(item.allowancePeriod?.startDate)} → ${_formatDate(item.allowancePeriod?.endDate)}',
          ),
        ],
      ),
    );
  }

  static String _formatDate(String? value) {
    if (value == null || value.trim().isEmpty) return '-';
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    return '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
