import 'package:flutter/material.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/employee_profile_model/skill_catalog_response.dart';

class SupervisorProfileSkillDropdownField extends StatelessWidget {
  const SupervisorProfileSkillDropdownField({
    super.key,
    required this.skills,
    required this.selectedSkillId,
    required this.onChanged,
  });

  final List<SkillCatalogItem> skills;
  final String? selectedSkillId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      initialValue: selectedSkillId,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: 'Choose skill',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      items: skills
          .map(
            (skill) => DropdownMenuItem<String>(
              value: skill.id,
              child: Text(
                skill.name?.trim().isNotEmpty == true ? skill.name! : 'Skill',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
