import 'package:flutter/material.dart';

class EmployeeAllowanceStatusMapper {
  static String label(int? status) {
    switch (status) {
      case 1:
        return 'Approved';
      case 2:
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  static Color textColor(int? status) {
    switch (status) {
      case 1:
        return const Color(0xFF059669);
      case 2:
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFFD97706);
    }
  }

  static Color backgroundColor(int? status) {
    switch (status) {
      case 1:
        return const Color(0xFFECFDF5);
      case 2:
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFFFFBEB);
    }
  }
}
