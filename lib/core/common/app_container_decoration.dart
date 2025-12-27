import 'package:flutter/material.dart';

BoxDecoration AppConatinerDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.grey.shade100),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
