import 'dart:convert';
import 'package:http/http.dart' as http;

class UsageApiService {
  static const String baseUrl =
    'http://172.50.6.190:8000/api/usage/';

  static Future<void> sendUsage({
    required String packageName,
    required String intent,
    required String timestamp,
  }) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "package": packageName,
        "intent": intent,
        "timestamp": timestamp,
      }),
    );
  }
}
