import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserNameFetch {
  static const String baseUrl = "http://127.0.0.1:8000";

  Future<String?> fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/auth/profile/"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body["name"]; // ✅ FIX HERE
      }

      if (response.statusCode == 401) {
        await prefs.remove("access_token");
        await prefs.remove("refresh_token");
        return null;
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
