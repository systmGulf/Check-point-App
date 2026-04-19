import 'package:flutter/material.dart';

class SupervisorProfileSkillRateDropdown extends StatelessWidget {
  const SupervisorProfileSkillRateDropdown({
    super.key,
    required this.selectedRate,
    required this.onChanged,
  });

  final int selectedRate;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      initialValue: selectedRate,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: 'Choose rate',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      items: List<DropdownMenuItem<int>>.generate(
        5,
        (index) {
          final value = index + 1;
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value / 5'),
          );
        },
      ),
      onChanged: onChanged,
    );
  }
}
