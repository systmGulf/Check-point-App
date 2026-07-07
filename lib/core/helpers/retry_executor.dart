import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Retries an async action with exponential backoff.
///
/// If the device has no internet, waits for connectivity before retrying.
class RetryExecutor {
  RetryExecutor._();

  static Future<T> retry<T>({
    required Future<T> Function() action,
    int maxAttempts = 3,
    Duration baseDelay = const Duration(seconds: 2),
  }) async {
    int attempts = 0;
    while (true) {
      try {
        attempts++;
        return await action();
      } catch (e) {
        if (attempts >= maxAttempts) rethrow;

        final connectivity = await Connectivity().checkConnectivity();
        if (connectivity.contains(ConnectivityResult.none)) {
          // Wait up to 10 seconds for connectivity to return.
          await Connectivity()
              .onConnectivityChanged
              .firstWhere(
                  (status) => !status.contains(ConnectivityResult.none))
              .timeout(
                const Duration(seconds: 10),
                onTimeout: () => [ConnectivityResult.none],
              );
        } else {
          await Future<void>.delayed(baseDelay * attempts);
        }
      }
    }
  }
}
