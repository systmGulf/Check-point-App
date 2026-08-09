import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
      return <BiometricType>[];
    }
  }

  static Future<bool> isBiometricSupported() async {
    try {
      final isDeviceSupported = await _auth.isDeviceSupported();
      final hasBiometricPermission = await hasBiometrics();
      final biometrics = await getBiometrics();

      return isDeviceSupported &&
          hasBiometricPermission &&
          biometrics.isNotEmpty;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await isBiometricSupported();
    if (!isAvailable) return false;

    try {
      return await _auth.authenticate(
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: false,
        ),
        localizedReason: 'Authenticate to continue',
      );
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> biometricAuthMethod() async {
    return authenticate();
  }

  static Future<bool> fingerPrintAuthenticate() async {
    final authPermission = await hasBiometrics();
    final biometrics = await getBiometrics();
    final supportsBiometricAuth = authPermission &&
        (biometrics.contains(BiometricType.fingerprint) ||
            biometrics.contains(BiometricType.face) ||
            biometrics.contains(BiometricType.iris) ||
            biometrics.contains(BiometricType.strong) ||
            biometrics.contains(BiometricType.weak));

    if (!supportsBiometricAuth) {
      return false;
    }

    return authenticate();
  }
}
