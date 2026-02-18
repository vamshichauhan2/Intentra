import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'usage_api_service.dart';

class UsageSyncService {
  static Future<void> sync() async {
    final prefs = await SharedPreferences.getInstance();
    final logs = prefs.getStringList("usage_queue") ?? [];

    print("🔄 SYNC CALLED");
    print("📦 LOG COUNT = ${logs.length}");

    if (logs.isEmpty) {
      print("⚠️ NOTHING TO SYNC");
      return;
    }

    for (final item in logs) {
      final data = jsonDecode(item);
      print("🚀 TRYING TO SEND → ${data["package"]}");

      await UsageApiService.sendUsage(
        packageName: data["package"],
        intent: data["intent"],
        timestamp: data["timestamp"],
      );
    }

    await prefs.remove("usage_queue");
    print("✅ SYNC FINISHED");
  }
}
