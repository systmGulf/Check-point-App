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
            CircleAvatar(
                radius: 50.r,
                child: Image.asset(
                  'assets/images/vodaphone.png',
                  fit: BoxFit.fill,
                )),
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
