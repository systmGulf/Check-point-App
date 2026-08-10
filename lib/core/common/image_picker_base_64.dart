import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

enum ImagePickSource {
  camera,
  gallery,
}

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImageBase64({
    required ImagePickSource source,
  }) async {
    final hasPermission = await _checkPermission(source);
    if (!hasPermission) return null;

    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: source == ImagePickSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        imageQuality: 100,
      );

      if (pickedImage == null) return null;

      final bytes = await pickedImage.readAsBytes();

      if (Platform.isIOS) {
        return _processImage(bytes);
      }

      return await compute(_processImage, bytes);
    } catch (e, s) {
      debugPrint('pickImageBase64 error => $e\n$s');
      return null;
    }
  }

  static Future<bool> _checkPermission(ImagePickSource source) async {
    if (Platform.isIOS && source == ImagePickSource.gallery) {
      return true;
    }

    Permission permission = source == ImagePickSource.camera
        ? Permission.camera
        : Permission.storage;

    final status = await permission.request();

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }
}

String _processImage(Uint8List imageBytes) {
  final decodedImage = img.decodeImage(imageBytes);
  if (decodedImage == null) return '';

  final resized = img.copyResize(
    decodedImage,
    width: 600,
    interpolation: img.Interpolation.average,
  );

  final compressed = img.encodeJpg(
    resized,
    quality: 85,
  );

  return base64Encode(compressed);
}
