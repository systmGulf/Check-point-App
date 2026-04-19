import 'package:employee_mangement/features/user_role/employee/employee_home/controller/assets/employee_assets_state.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_asset_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_loan_model/employee_loans_response.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmployeeLoanDashboardBody extends StatelessWidget {
  const EmployeeLoanDashboardBody({
    super.key,
    required this.state,
    required this.onRefresh,
  });

  final EmployeeAssetsState state;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final items = state.loans;

    if (state.isLoadingLoans && items.isEmpty) {
      return const _EmployeeLoanDashboardSkeleton();
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

    final totalAmount =
        items.fold<double>(0, (sum, item) => sum + (item.amount?.toDouble() ?? 0));
    final totalInstallements = items.fold<double>(
      0,
      (sum, item) => sum + (item.loanInstallementAmount?.toDouble() ?? 0),
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
              title: 'Loan Requests',
              value: items.length.toString(),
              icon: Icons.request_page_outlined,
            ),
            EmployeeAssetSummaryCard(
              title: 'Total Amount',
              value: _formatAmount(totalAmount),
              icon: Icons.payments_outlined,
            ),
            EmployeeAssetSummaryCard(
              title: 'Total Installements',
              value: _formatAmount(totalInstallements),
              icon: Icons.stacked_line_chart_outlined,
            ),
            EmployeeAssetSummaryCard(
              title: 'Active',
              value: items.isEmpty ? '0' : 'Yes',
              icon: Icons.timeline_rounded,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Loan Requests',
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
              child: Text('No loan data'),
            ),
          )
        else
          ...List<Widget>.generate(
            items.length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 10),
              child: _EmployeeLoanCard(item: items[index]),
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

class _EmployeeLoanCard extends StatelessWidget {
  const _EmployeeLoanCard({
    required this.item,
  });

  final EmployeeLoanItem item;

  @override
  Widget build(BuildContext context) {
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
                  item.code?.trim().isNotEmpty == true ? item.code! : 'Loan',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _MetaLine(
            title: 'Requester',
            value: item.requester?.requesterName ?? '-',
          ),
          _MetaLine(
            title: 'Amount',
            value: '${(item.amount ?? 0).toStringAsFixed(0)} EGP',
          ),
          _MetaLine(
            title: 'Installement',
            value: '${(item.loanInstallementAmount ?? 0).toStringAsFixed(0)} EGP',
          ),
          _MetaLine(
            title: 'Loan Request Id',
            value: item.loanRequestId ?? '-',
          ),
          _MetaLine(
            title: 'Period',
            value:
                '${_formatDate(item.period?.startDate)} → ${_formatDate(item.period?.endDate)}',
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

class _EmployeeLoanDashboardSkeleton extends StatelessWidget {
  const _EmployeeLoanDashboardSkeleton();

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
                icon: Icons.request_page_outlined,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Loan Requests',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...List<Widget>.generate(
            4,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: _LoanSkeletonCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoanSkeletonCard extends StatelessWidget {
  const _LoanSkeletonCard();

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
          Text('LRQ-0000'),
          SizedBox(height: 8),
          Text('Requester: ...'),
          SizedBox(height: 6),
          Text('Amount: ...'),
          SizedBox(height: 6),
          Text('Installement: ...'),
          SizedBox(height: 6),
          Text('Period: ...'),
        ],
      ),
    );
  }
}
