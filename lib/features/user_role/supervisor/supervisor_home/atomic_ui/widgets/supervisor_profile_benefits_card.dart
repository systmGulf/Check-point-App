import 'package:flutter/material.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_profile_model/employee_beneficiary_benefits_response.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class SupervisorProfileBenefitsCard extends StatelessWidget {
  const SupervisorProfileBenefitsCard({
    super.key,
    required this.benefits,
  });

  final List<EmployeeBeneficiaryBenefitItem> benefits;

  @override
  Widget build(BuildContext context) {
    if (benefits.isEmpty) {
      return Container(
        height: 220,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ColorsManger.borderColor),
        ),
        child: Text(
          'No benefits found',
          style: AppStylesManger.font16BoldBlack,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorsManger.borderColor),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                const Icon(Icons.card_giftcard, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Benefits (${benefits.length})',
                  style: AppStylesManger.font16BoldBlack,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: benefits.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = benefits[index];
              final elements = item.benefitElements;
              final totalAmount =
                  elements.fold<num>(0, (sum, e) => sum + (e.amount ?? 0));
              final dependentNames = item.benefitData?.dependents
                      .map((e) => (e.name ?? '').trim())
                      .where((name) => name.isNotEmpty)
                      .toList() ??
                  const <String>[];

              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.benefitName ?? '--',
                            style: AppStylesManger.font14BoldBlack,
                          ),
                        ),
                        _StatusChip(status: item.status ?? 0),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.benefitPlanName ?? '--',
                      style: AppStylesManger.font12RegularGrey,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TinyInfoChip(
                          icon: Icons.event,
                          text:
                              '${item.period?.startDate ?? '--'} - ${item.period?.endDate ?? '--'}',
                        ),
                        _TinyInfoChip(
                          icon: Icons.attach_money,
                          text: 'Total: $totalAmount',
                        ),
                        _TinyInfoChip(
                          icon: Icons.medical_services_outlined,
                          text: 'Elements: ${elements.length}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (dependentNames.isNotEmpty) ...[
                      Text(
                        'Dependents',
                        style: AppStylesManger.font12RegularGrey,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: dependentNames
                            .map(
                              (name) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF3F4F6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  name,
                                  style: AppStylesManger.font12RegularBlack,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Text(
                      'Top Elements',
                      style: AppStylesManger.font12RegularGrey,
                    ),
                    const SizedBox(height: 4),
                    ...elements.take(3).map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              '- ${e.name ?? '--'}: ${e.amount ?? 0}',
                              style: AppStylesManger.font12RegularBlack,
                            ),
                          ),
                        ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final int status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      1 => ('Approved', Colors.green),
      2 => ('Rejected', Colors.red),
      _ => ('Pending', Color(0xffD97706)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppStylesManger.font12RegularBlack.copyWith(color: color),
      ),
    );
  }
}

class _TinyInfoChip extends StatelessWidget {
  const _TinyInfoChip({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xffEFF6FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: ColorsManger.primaryColor),
          const SizedBox(width: 4),
          Text(text, style: AppStylesManger.font12RegularBlack),
        ],
      ),
    );
  }
}
