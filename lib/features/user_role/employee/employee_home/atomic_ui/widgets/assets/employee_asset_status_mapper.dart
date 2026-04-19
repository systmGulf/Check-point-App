import 'package:flutter/material.dart';

class EmployeeAssetStatusMapper {
  static String label(int? status) {
    switch (status) {
      case 1:
        return 'Approved';
      case 2:
        return 'Rejected';
      case 3:
        return 'Returned';
      default:
        return 'Pending';
    }
  }

  static Color color(int? status) {
    switch (status) {
      case 1:
        return const Color(0xFF059669);
      case 2:
        return const Color(0xFFDC2626);
      case 3:
        return const Color(0xFF2563EB);
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
      case 3:
        return const Color(0xFFDBEAFE);
      default:
        return const Color(0xFFFFFBEB);
    }
  }
}
