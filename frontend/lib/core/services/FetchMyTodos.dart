import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FetchTodaysTodo {
  static const String baseUrl = "http://127.0.0.1:8000";
  static const String endpoint = "$baseUrl/api/todos/tasks/";

  Future<List<dynamic>> getMyTodaysTodo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // 👈 LIST
      }

      if (response.statusCode == 401) {
        await prefs.clear();
      }

      return [];
    } catch (_) {
      return [];
    }
  }
}