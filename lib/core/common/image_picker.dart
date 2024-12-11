import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../dependencyـinjection/registerـfactory.dart';

Future<String?> pickImage() async {
  try {
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      File imageFile = File(image.path);

      final String base64Image = await computeBase64Encoding(imageFile);
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

Future<String> computeBase64Encoding(File imageFile) async {
  final ReceivePort receivePort = ReceivePort();

  await Isolate.spawn(
      _base64EncodeImage, [imageFile.path, receivePort.sendPort]);

  final String base64String = await receivePort.first as String;

  return base64String;
}

void _base64EncodeImage(List<dynamic> args) async {
  final String imagePath = args[0];
  final SendPort sendPort = args[1];

  try {
    final File imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      return;
    }
    img.Image resized = img.copyResize(image, width: 600);
    List<int> compressedBytes = img.encodeJpg(resized, quality: 85);
    String base64String = base64Encode(compressedBytes);

    sendPort.send(base64String);
  } catch (e) {
    sendPort.send('');
  }
}
