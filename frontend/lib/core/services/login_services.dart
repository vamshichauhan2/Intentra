import 'dart:convert';
import 'package:http/http.dart' as http;


class LoginMe{
  static const String baseUrl="http://127.0.0.1:8000/";
  Future<Map<String,dynamic>> loginIntoIntentra(Map<String ,dynamic> data)async{

     try{
      final response=await http.post(
        Uri.parse("$baseUrl/api/auth/login/"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return {
          "success": true,
          "access": body["access"],
          "refresh": body["refresh"],
          "message": "login successFully",
        };
      }
      if (response.statusCode == 400 || response.statusCode==401) {
        
        return {
          "success": false,
          "message":"Invalid Username and Password",
        };
      }
      return{
        "success":false,
        "message":"Server Error .Try Again Later",
      };

     }catch (_) {
      // ❌ NETWORK / INTERNET ISSUE
      return {
        "success": false,
        "message": "No internet connection.",
      };
    }

  }


}