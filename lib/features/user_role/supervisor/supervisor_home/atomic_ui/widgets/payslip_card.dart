import 'package:flutter/material.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_payslip_model/payslip_model.dart';

class PayslipCard extends StatelessWidget {
  final PayrollModel payslip;

  const PayslipCard({super.key, required this.payslip});

  @override
  Widget build(BuildContext context) {
    final profile = payslip.payrollProfile;
    final analysis = payslip.analysis;
    final periodText = _monthName(profile.period.month, profile.period.year);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xffEEF2FF),
                  child: Icon(Icons.receipt_long, color: Color(0xff4338CA)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    profile.owner.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xffF3F4F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    periodText,
                    style: const TextStyle(
                      color: Color(0xff4B5563),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xffECFDF5), Color(0xffDCFCE7)],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xff86EFAC)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Net Salary",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xff14532D),
                    ),
                  ),
                  Text(
                    "EGP ${payslip.netSalary.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff166534),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    "Gross",
                    profile.grossSalary,
                    const Color(0xffEEF2FF),
                    const Color(0xff4338CA),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    "Additions",
                    analysis.totalAdditions,
                    const Color(0xffECFEFF),
                    const Color(0xff0E7490),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    "Deductions",
                    analysis.totalDeductions,
                    const Color(0xffFEF2F2),
                    const Color(0xffB91C1C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ...profile.components.take(4).map(
                      (component) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xffF9FAFB),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xffE5E7EB)),
                        ),
                        child: Text(
                          "${component.name}: ${component.amount.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xff374151),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(
    String title,
    double value,
    Color bg,
    Color fg,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xff6B7280),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            value.toStringAsFixed(0),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: fg,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _monthName(int month, int year) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final safeMonth = month < 1 || month > 12 ? 1 : month;
    return '${months[safeMonth]} $year';
  }
}
