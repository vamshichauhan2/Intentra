import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class TodoApi {
  static const String url = "http://127.0.0.1:8000";
  static const String baseUrl = "$url/api/todos/create/";

  static Future<void> createTask({
    required String title,
    required bool todayTarget,
    required int timeNeeded,
    required int priority,
  }) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "title": title,
        "today_target": todayTarget,
        "time_needed": timeNeeded,
        "priority": priority,
      }),
    );
  }
}