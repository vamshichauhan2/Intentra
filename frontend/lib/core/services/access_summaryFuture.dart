import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SummmeryFetch {
  static const String baseUrl = "http://127.0.0.1:8000";

  Future<Map<String, dynamic>?> GETMySummary() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/features-summary/"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      if (response.statusCode == 401) {
        await prefs.clear();
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}
