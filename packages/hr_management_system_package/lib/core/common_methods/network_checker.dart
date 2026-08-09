import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkChecker {
  Future<bool> checkConnectivity({
    FutureOr<void> Function()? onSuccess,
    FutureOr<void> Function()? onFailure,
  }) async {
    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      final hasConnection = connectivityResults.any(
        (result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet ||
            result == ConnectivityResult.vpn ||
            result == ConnectivityResult.bluetooth ||
            result == ConnectivityResult.other,
      );

      if (hasConnection) {
        await onSuccess?.call();
        return true;
      }

      await onFailure?.call();
      return false;
    } catch (_) {
      await onFailure?.call();
      return false;
    }
  }
}
