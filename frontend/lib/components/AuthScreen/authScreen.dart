import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/core/services/login_services.dart'; 

import 'package:shared_preferences/shared_preferences.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String username = "";
  String password = "";
  String errorMsg = "";
  bool isLoading = false; 

  final LoginMe authLogin= LoginMe(); 
  Future<void> _login() async {
  if (username.isEmpty || password.isEmpty) {
    setState(() {
      errorMsg = "Username or password cannot be empty";
    });
    return;
  }

  setState(() {
    isLoading = true;
    errorMsg = "";
  });

  final result = await authLogin.loginIntoIntentra({
    "username": username,
    "password": password,
  });

  if (!mounted) return; // 🔐 async safety

  setState(() => isLoading = false);

  if (result["success"] == true) {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString("access_token", result["access"]);
  await prefs.setString("refresh_token", result["refresh"]);

  Navigator.pushNamedAndRemoveUntil(
    context,
    AppRoutes.home,
    (route) => false,
  );
}
 else {
    setState(() {
      errorMsg = result["message"];
    });
  }
}


  void _signup(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.signup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LOGIN")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                decoration: const InputDecoration(labelText: 'Username'),
                onChanged: (value) {
                  username = value;
                  if (errorMsg.isNotEmpty) {
                    setState(() => errorMsg = "");
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) {
                  password = value;
                  if (errorMsg.isNotEmpty) {
                    setState(() => errorMsg = "");
                  }
                },
              ),
            ),

            // 🔴 ERROR MESSAGE PLACEMENT
            if (errorMsg.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  errorMsg,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
  onPressed: isLoading ? null : _login,
  child: isLoading
      ? const SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
      : const Text("Login"),
),

                OutlinedButton(
                  onPressed: () => _signup(context),
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
