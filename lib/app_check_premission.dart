import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permission Check'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          PermissionCard(
            title: 'Location Permission',
            description:
                'Allow the app to access your location all the time for proper functionality.',
            buttonText: 'Check Location Permission',
            onPressed: () async {
              if (await Permission.locationAlways.isGranted) {
                showMessage(context, 'Location permission is granted.');
              } else {
                await Permission.locationAlways.request();
              }
            },
          ),
          PermissionCard(
            title: 'Battery Optimization',
            description:
                'Disable battery optimization to ensure the app runs properly in the background.',
            buttonText: 'Open Battery Optimization Settings',
            onPressed: () {
              openAppSettings();
            },
          ),
          PermissionCard(
            title: 'Background Restriction',
            description:
                'Ensure the app is not restricted from running in the background.',
            buttonText: 'Open Background Restriction Settings',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class PermissionCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  const PermissionCard({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
