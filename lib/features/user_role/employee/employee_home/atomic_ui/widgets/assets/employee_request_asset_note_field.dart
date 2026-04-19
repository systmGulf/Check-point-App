import 'package:flutter/material.dart';

class EmployeeRequestAssetNoteField extends StatelessWidget {
  const EmployeeRequestAssetNoteField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: 4,
      maxLines: 6,
      decoration: InputDecoration(
        hintText: 'Add your request note',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
