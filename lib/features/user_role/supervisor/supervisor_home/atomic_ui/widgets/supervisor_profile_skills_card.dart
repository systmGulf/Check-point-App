import 'package:flutter/material.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_profile_model/user_skills_response.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class SupervisorProfileSkillsCard extends StatelessWidget {
  const SupervisorProfileSkillsCard({
    super.key,
    required this.skills,
  });

  final List<UserSkillItem> skills;

  @override
  Widget build(BuildContext context) {
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
            'Skills',
            style: AppStylesManger.font16BoldBlack,
          ),
          verticalSpace(12),
          const Divider(height: 1),
          verticalSpace(12),
          if (skills.isEmpty)
            Text(
              'No skills available',
              style: AppStylesManger.font14RegularBlack,
            )
          else
            ...skills.map((skill) => ProfileSkillItem(skill: skill)),
        ],
      ),
    );
  }
}

class ProfileSkillItem extends StatelessWidget {
  const ProfileSkillItem({
    super.key,
    required this.skill,
  });

  final UserSkillItem skill;

  @override
  Widget build(BuildContext context) {
    final skillName = (skill.skillName ?? '--').trim();
    final rate = skill.rate ?? 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xffF8FAFC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                skillName.isEmpty ? '--' : skillName,
                style: AppStylesManger.font14BoldBlack,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            horizontalSpace(8),
            Row(
              children: List.generate(5, (index) {
                final filled = index < rate;
                return Icon(
                  filled ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 18,
                  color: filled ? Colors.amber : ColorsManger.grey9c,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
