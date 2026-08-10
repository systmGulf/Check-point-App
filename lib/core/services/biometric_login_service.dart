import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../enums/role_enum.dart';

class SavedLoginAccount {
  const SavedLoginAccount({
    required this.email,
    required this.password,
    required this.role,
  });

  final String email;
  final String password;
  final Role role;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role.name,
    };
  }

  factory SavedLoginAccount.fromJson(Map<String, dynamic> json) {
    return SavedLoginAccount(
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      role: Role.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => Role.Employee,
      ),
    );
  }
}

enum BiometricLoginResult {
  started,
  unavailable,
  noSavedAccount,
  cancelled,
}

class BiometricLoginService {
  BiometricLoginService({
    FlutterSecureStorage? secureStorage,
    LocalAuthentication? localAuthentication,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _localAuthentication = localAuthentication ?? LocalAuthentication();

  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuthentication;

  String _storageKey(Role role) => 'saved_login_${role.name.toLowerCase()}';

  Future<void> saveAccount({
    required String email,
    required String password,
    required Role role,
  }) async {
    final account = SavedLoginAccount(
      email: email,
      password: password,
      role: role,
    );
    await _secureStorage.write(
      key: _storageKey(role),
      value: jsonEncode(account.toJson()),
    );
  }

  Future<SavedLoginAccount?> getSavedAccount(Role role) async {
    final rawValue = await _secureStorage.read(key: _storageKey(role));
    if (rawValue == null || rawValue.trim().isEmpty) {
      return null;
    }

    try {
      final json = jsonDecode(rawValue) as Map<String, dynamic>;
      final account = SavedLoginAccount.fromJson(json);
      if (account.email.trim().isEmpty || account.password.isEmpty) {
        return null;
      }
      return account;
    } catch (_) {
      return null;
    }
  }

  Future<bool> hasSavedAccount(Role role) async {
    return (await getSavedAccount(role)) != null;
  }

  Future<bool> isBiometricAvailable() async {
    try {
      final isDeviceSupported = await _localAuthentication.isDeviceSupported();
      final canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      final availableBiometrics =
          await _localAuthentication.getAvailableBiometrics();

      return isDeviceSupported &&
          (canCheckBiometrics || availableBiometrics.isNotEmpty);
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to sign in quickly',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
