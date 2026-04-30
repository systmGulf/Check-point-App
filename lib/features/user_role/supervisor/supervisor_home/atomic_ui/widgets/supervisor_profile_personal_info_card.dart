import 'package:flutter/material.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_profile_model/employee_profile_response.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class SupervisorProfilePersonalInfoCard extends StatelessWidget {
  const SupervisorProfilePersonalInfoCard({
    super.key,
    required this.profile,
    // required this.onEdit,
  });

  final EmployeeProfileValue profile;
  // final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final p = profile.personalInfo;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorsManger.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: AppStylesManger.font16BoldBlack,
          ),
          // Row(
          //   children: [
          //  Icon(Icons.edit_outlined, size: 18, color: ColorsManger.grey9c),
          // horizontalSpace(6),
          // const Spacer(),
          // InkWell(
          //   onTap: onEdit,
          //   borderRadius: BorderRadius.circular(8),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(
          //       horizontal: 6,
          //       vertical: 4,
          //     ),
          //     child: Text(
          //       'Edit',
          //       style: AppStylesManger.font14BoldBlack.copyWith(
          //         color: ColorsManger.primaryColor,
          //       ),
          //     ),
          //   ),
          // ),
          //   ],
          // ),
          verticalSpace(12),
          const Divider(height: 1),
          verticalSpace(12),
          Row(
            children: [
              Expanded(
                child: ProfileFieldItem(
                  label: 'First Name',
                  value: p?.firstName ?? '--',
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: ProfileFieldItem(
                  label: 'Last Name',
                  value: p?.lastName ?? '--',
                ),
              ),
            ],
          ),
          verticalSpace(10),
          Row(
            children: [
              Expanded(
                child: ProfileFieldItem(
                  label: 'Arabic First Name',
                  value: p?.arabicFirstName ?? '--',
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: ProfileFieldItem(
                  label: 'Arabic Last Name',
                  value: p?.arabicLastName ?? '--',
                ),
              ),
            ],
          ),
          verticalSpace(10),
          Row(
            children: [
              Expanded(
                child: ProfileFieldItem(
                  label: 'Date of Birth',
                  value: p?.dateOfBirth ?? '--',
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: ProfileFieldItem(
                  label: 'Gender',
                  value: _genderText(p?.gender),
                ),
              ),
            ],
          ),
          verticalSpace(10),
          Row(
            children: [
              Expanded(
                child: ProfileFieldItem(
                  label: 'Nationality',
                  value: p?.nationality ?? '--',
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: ProfileFieldItem(
                  label: 'Marital Status',
                  value: _maritalStatusText(p?.maritalStatus),
                ),
              ),
            ],
          ),
          verticalSpace(10),
          ProfileFieldItem(
            label: 'National ID',
            value: p?.nationalId ?? '--',
          ),
        ],
      ),
    );
  }
}

class ProfileFieldItem extends StatelessWidget {
  const ProfileFieldItem({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStylesManger.font12RegularGrey),
        verticalSpace(4),
        Text(
          value,
          style: AppStylesManger.font14RegularBlack,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

String _genderText(int? gender) {
  switch (gender) {
    case 0:
      return 'Male';
    case 1:
      return 'Female';
    default:
      return '--';
  }
}

String _maritalStatusText(int? status) {
  switch (status) {
    case 0:
      return 'Single';
    case 1:
      return 'Married';
    case 2:
      return 'Divorced';
    case 3:
      return 'Widowed';
    default:
      return '--';
  }
}
