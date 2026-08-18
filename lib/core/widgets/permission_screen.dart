import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/colors.dart';
import 'custom_app_button.dart';

class PermissionScreen extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

  const PermissionScreen(
      {Key? key, required this.onRetry, required this.onOpenSettings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Permissions Required'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 220.w,
              height: 96.h,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
              decoration: BoxDecoration(
                color: ColorsManger.primaryColor,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: ColorsManger.primaryColor.withOpacity(0.45),
                    blurRadius: 24,
                    spreadRadius: 3,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Enlighten',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            verticalSpace(20),
            Text(
              'Please grant the following permissions for the app to work correctly:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              '1. Location (Always)\n2. Ignore Battery Optimizations',
              style: TextStyle(fontSize: 16.sp, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            CustomAppButton(
                width: 300.w,
                textButton: 'Grant Permissions',
                buttonColor: ColorsManger.primaryColor,
                onPressed: onRetry),
            SizedBox(height: 10),
            TextButton(
              onPressed: onOpenSettings,
              child: Text('Open App Settings',
                  style: TextStyle(color: ColorsManger.primaryColor)),
            ),
          ],
        ),
      ),
    );
  }
}
