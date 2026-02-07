import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRegister {
  //static const String baseUrl = "http://10.0.2.2:8000";
  static const String baseUrl="http://127.0.0.1:8000/";
  //static const String baseUrl = "http://localhost:8000";


  Future<Map<String, dynamic>> registerMe(
      Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/register/"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      // ✅ SUCCESS
      if (response.statusCode == 201) {
        return {
          "success": true,
          "message": "Account created successfully",
        };
      }

      // ❌ VALIDATION ERRORS (400)
      if (response.statusCode == 400) {
        final body = jsonDecode(response.body);
        return {
          "success": false,
          "message": _mapValidationError(body),
        };
      }

      // ❌ SERVER ERROR
      return {
        "success": false,
        "message": "Server error. Try again later.",
      };
    } catch (_) {
      // ❌ NETWORK / INTERNET ISSUE
      return {
        "success": false,
        "message": "No internet connection.",
      };
    }
  }

  // 🔐 ERROR SANITIZER
  String _mapValidationError(dynamic body) {
    if (body is Map<String, dynamic>) {
      if (body.containsKey("email")) {
        return "Email already exists";
      }
      if (body.containsKey("username")) {
        return "Username already taken";
      }
      if (body.containsKey("password")) {
        return "Password is too weak";
      }
      if (body.containsKey("phone")) {
        return "Phone number already registered";
      }
    }
    return "Invalid details. Please check inputs.";
  }
}
