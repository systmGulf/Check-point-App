import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String?> pickImage() async {
  try {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    final imageFile = File(image.path);
    return await base64EncodeImage(imageFile);
  } catch (e) {
    debugPrint('Image Exception ==> $e');
    return null;
  }
}

Future<bool> _checkPermissions() async {
  final permissionStatus = await Permission.photos.request();
  if (permissionStatus.isGranted) {
    return true;
  } else if (permissionStatus.isDenied) {
    // await _showAlertPermissionsDialog();
    return false;
  }
  return false;
}

// Future<void> _showAlertPermissionsDialog() {
//   return showCupertinoDialog(
//     context: getIt<GlobalKey<NavigatorState>>().currentState!.context,
//     builder: (context) {
//       return CupertinoAlertDialog(
//         title: const Text('Permissions Denied'),
//         content: const Text('Allow access to gallery and photos'),
//         actions: <CupertinoDialogAction>[
//           CupertinoDialogAction(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           const CupertinoDialogAction(
//             isDefaultAction: true,
//             onPressed: openAppSettings,
//             child: Text('Settings'),
//           ),
//         ],
//       );
//     },
//   );
// }

Future<String> base64EncodeImage(File imageFile) async {
  try {
    final imageBytes = await imageFile.readAsBytes();
    final base64 = await compute(_processImage, imageBytes);
    return base64;
  } catch (e) {
    debugPrint('Error in base64EncodeImage ==> $e');
    return '';
  }
}

String _processImage(Uint8List imageBytes) {
  final image = img.decodeImage(imageBytes);
  if (image == null) return '';
  final resized = img.copyResize(image, width: 600);
  final compressedBytes = img.encodeJpg(resized, quality: 87);
  return base64Encode(compressedBytes);
}
