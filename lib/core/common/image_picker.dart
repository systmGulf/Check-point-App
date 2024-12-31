import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../dependency%D9%80injection/register%D9%80factory.dart';

Future<String?> pickImage() async {
  try {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final imageFile = File(image.path);
      final base64Image = await base64EncodeImage(imageFile);
      return base64Image;
    }

    return null;
  } on Exception catch (e) {
    final permissionStatus = await Permission.photos.status;

    if (permissionStatus.isDenied) {
      await _showAlertPermissionsDialog();
    } else {
      debugPrint('Image Exception ==> $e');
    }
  }
  return null;
}

Future<void> _showAlertPermissionsDialog() {
  return showCupertinoDialog(
    context: getIt<GlobalKey<NavigatorState>>().currentState!.context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: const Text('Permissions Denied'),
        content: const Text('Allow access to gallery and photos'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          const CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: openAppSettings,
            child: Text('Settings'),
          ),
        ],
      );
    },
  );
}

Future<String> base64EncodeImage(File imageFile) async {
  try {
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      return '';
    }

    final resized = img.copyResize(image, width: 600);
    final List<int> compressedBytes = img.encodeJpg(resized, quality: 85);
    return base64Encode(compressedBytes);
  } catch (e) {
    debugPrint('Error in base64EncodeImage ==> $e');
    return '';
  }
}
