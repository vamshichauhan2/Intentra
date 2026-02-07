import 'dart:convert';
import 'package:flutter/services.dart';

class UsageService {
  static const MethodChannel _channel =
      MethodChannel('intentra/usage');

  static Future<void> startTracking() async {
    await _channel.invokeMethod('startTracking');
  }

  static Future<List<Map<String, dynamic>>> getLogs() async {
    final raw =
        await _channel.invokeMethod<String>('getLogs');

    final List decoded =
        jsonDecode(raw ?? '[]');

    return decoded.cast<Map<String, dynamic>>();
  }
}
