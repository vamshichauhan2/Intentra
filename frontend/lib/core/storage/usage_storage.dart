import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UsageStorage {
  static const _key = 'flutter_usage_cache';

  static Future<void> save(List<Map<String, dynamic>> logs) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(logs));
  }

  static Future<List<Map<String, dynamic>>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .cast<Map<String, dynamic>>();
  }
}
