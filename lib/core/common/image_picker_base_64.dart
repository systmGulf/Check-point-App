import 'dart:async';
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

  /// Main method
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
        imageQuality: 100, // نسيب الجودة كاملة ونضغط بإيدنا
      );

      if (pickedImage == null) return null;

      final file = File(pickedImage.path);
      return await _encodeAndCompress(file);
    } catch (e, s) {
      debugPrint('pickImageBase64 error => $e\n$s');
      return null;
    }
  }

  static Future<bool> _checkPermission(ImagePickSource source) async {
    Permission permission;

    if (source == ImagePickSource.camera) {
      permission = Permission.camera;
    } else {
      permission = Platform.isIOS ? Permission.photos : Permission.storage;
    }

    final status = await permission.request();

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

  static Future<String> _encodeAndCompress(File file) async {
    final bytes = await file.readAsBytes();
    return compute(_processImage, bytes);
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
