import 'package:flutter/material.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_profile_model/employee_profile_response.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class SupervisorProfileSummaryCard extends StatelessWidget {
  const SupervisorProfileSummaryCard({
    super.key,
    required this.profile,
  });

  final EmployeeProfileValue profile;

  @override
  Widget build(BuildContext context) {
    final personal = profile.personalInfo;
    final contact = profile.contactInfo;
    final spec = profile.employeeSpecification;

    final englishName =
        '${personal?.firstName ?? ''} ${personal?.lastName ?? ''}'.trim();
    final arabicName =
        '${personal?.arabicFirstName ?? ''} ${personal?.arabicLastName ?? ''}'
            .trim();

    final code = profile.code ?? '--';
    final email = contact?.email ?? '--';
    final phone = contact?.phone ?? '--';
    final department = spec?.organizationUnitName ?? '--';
    final address = _buildAddress(contact?.address);
    final manager = spec?.managerName ?? '--';
    final hiringDate = spec?.hiringDate ?? '--';
    final jobTitle = spec?.jobTitle ?? '--';
    final experience = '${spec?.yearOfExperience ?? 0}+';

    final initials = _buildInitials(
      personal?.firstName,
      personal?.lastName,
      personal?.arabicFirstName,
      personal?.arabicLastName,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorsManger.borderColor),
      ),
      child: Column(
        children: [
          Container(
            height: 86,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xffBDC7E6), Color(0xff4989E8)],
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -34),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 74,
                      height: 74,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xffDDE2F0),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: AppStylesManger.font20SemiBoldBlack,
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      end: 2,
                      bottom: 2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(10),
                Text(
                  englishName.isEmpty ? '--' : englishName,
                  style: AppStylesManger.font18BoldBlack,
                ),
                verticalSpace(4),
                Text(
                  arabicName.isEmpty ? '--' : '($arabicName)',
                  style: AppStylesManger.font16BoldBlack,
                ),
                verticalSpace(2),
                Text(code, style: AppStylesManger.font12RegularGrey),
                verticalSpace(10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    ProfileTagItem(
                      text: 'Exp $experience',
                      color: Colors.blue.shade50,
                    ),
                    ProfileTagItem(
                      text: _employmentType(profile.employmentType),
                      color: Colors.red.shade50,
                    ),
                    ProfileTagItem(
                      text: jobTitle,
                      color: Colors.teal.shade50,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  ProfileInfoRow(
                    label: 'Email',
                    value: email,
                    icon: Icons.mail_outline,
                  ),
                  ProfileInfoRow(
                    label: 'Phone',
                    value: phone,
                    icon: Icons.phone_outlined,
                  ),
                  ProfileInfoRow(
                    label: 'Organization Unit',
                    value: department,
                    icon: Icons.corporate_fare_outlined,
                  ),
                  ProfileInfoRow(
                    label: 'Address',
                    value: address,
                    icon: Icons.location_on_outlined,
                  ),
                  const Divider(),
                  ProfileInfoRow(
                    label: 'Manager',
                    value: manager,
                    icon: Icons.person_outline,
                  ),
                  ProfileInfoRow(
                    label: 'Hiring Date',
                    value: hiringDate,
                    icon: Icons.calendar_month_outlined,
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

class ProfileTagItem extends StatelessWidget {
  const ProfileTagItem({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: AppStylesManger.font12RegularBlack),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: AppStylesManger.font14RegularBlack,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, size: 18, color: ColorsManger.grey9c),
          const SizedBox(width: 4),
          Text(label, style: AppStylesManger.font12RegularGrey),
        ],
      ),
    );
  }
}

String _buildAddress(EmployeeAddress? address) {
  if (address == null) return '--';
  final parts = [
    address.street,
    address.cityName,
    address.countryName,
  ].where((e) => (e ?? '').trim().isNotEmpty).cast<String>().toList();

  return parts.isEmpty ? '--' : parts.join(', ');
}

String _buildInitials(
  String? first,
  String? last,
  String? arabicFirst,
  String? arabicLast,
) {
  final en = '${first ?? ''} ${last ?? ''}'.trim();
  if (en.isNotEmpty) {
    final words = en.split(' ').where((e) => e.isNotEmpty).toList();
    final firstChar = words.isNotEmpty ? words.first.substring(0, 1) : 'A';
    final secondChar = words.length > 1 ? words[1].substring(0, 1) : firstChar;
    return '${firstChar.toUpperCase()}${secondChar.toUpperCase()}';
  }

  final ar = '${arabicFirst ?? ''} ${arabicLast ?? ''}'.trim();
  if (ar.isNotEmpty) {
    final words = ar.split(' ').where((e) => e.isNotEmpty).toList();
    final firstChar = words.isNotEmpty ? words.first.substring(0, 1) : 'A';
    final secondChar = words.length > 1 ? words[1].substring(0, 1) : firstChar;
    return '$firstChar$secondChar';
  }

  return 'AA';
}

String _employmentType(int? type) {
  switch (type) {
    case 0:
      return 'Full Time';
    case 1:
      return 'Part Time';
    case 2:
      return 'Contract';
    default:
      return '--';
  }
}
