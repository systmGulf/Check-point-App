import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:employee_mangement/core/dependency%D9%80injection/register%D9%80factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String?> pickImage() async {
  try {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final imageFile = File(image.path);

      final base64Image = await computeBase64Encoding(imageFile);
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
  final receivePort = ReceivePort();

  try {
    await Isolate.spawn(
      _base64EncodeImage,
      [imageFile.path, receivePort.sendPort],
    );

    final base64String = await receivePort.first as String;

    return base64String;
  } catch (e) {
    debugPrint('Error in computeBase64Encoding: $e');
    return '';
  } finally {
    receivePort.close();
  }
}

Future<void> _base64EncodeImage(List<dynamic> args) async {
  final imagePath = args[0] as String;
  final sendPort = args[1] as SendPort;

  try {
    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      sendPort.send('');
      return;
    }

    final resized = img.copyResize(image, width: 600);
    final List<int> compressedBytes = img.encodeJpg(resized, quality: 85);
    final base64String = base64Encode(compressedBytes);

    sendPort.send(base64String);
  } catch (e) {
    debugPrint('Error in _base64EncodeImage: $e');
    sendPort.send('');
  }
}
