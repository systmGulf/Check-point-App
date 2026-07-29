import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineSyncManager {
  static const String _queueKey = 'offline_attendance_queue';

  static Future<void> enqueueRequest(Map<String, dynamic> requestBody) async {
    final prefs = await SharedPreferences.getInstance();
    final currentQueue = prefs.getStringList(_queueKey) ?? [];
    currentQueue.add(jsonEncode({
      'timestamp': DateTime.now().toIso8601String(),
      'body': requestBody,
    }));
    await prefs.setStringList(_queueKey, currentQueue);
  }

  static Future<List<Map<String, dynamic>>> getQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final rawQueue = prefs.getStringList(_queueKey) ?? [];
    return rawQueue.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Future<void> clearQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_queueKey);
  }

  static Future<void> processSyncQueue(Future<void> Function(Map<String, dynamic> body) syncAction) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) return;

    final queue = await getQueue();
    if (queue.isEmpty) return;

    for (final item in queue) {
      try {
        await syncAction(item['body']);
      } catch (e) {
        // Keep retrying on next cycle if request fails
        continue;
      }
    }
    await clearQueue();
  }
}
