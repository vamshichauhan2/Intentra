import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/core/services/auth_services.dart'; 
// 👉 added: import service

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email = "";
  String otp = "";
  String firstName = "";
  String lastName = "";
  String dob = "";
  String phone = "";
  String password = "";
  String repassword = "";
  String username = "";

  bool otpSent = false;
  bool emailVerified = false;
  String? errorMsg;
  bool isLoading = false; 
  // 👉 added: loading state

  final AuthRegister authRegister = AuthRegister(); 
  // 👉 added: service object

  Future<void> _signUp() async {
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        dob.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        repassword.isEmpty ||
        username.isEmpty) {
      setState(() => errorMsg = "All fields are required");
      return;
    }

    if (password != repassword) {
      setState(() => errorMsg = "Passwords do not match");
      return;
    }

    setState(() {
      errorMsg = null;
      isLoading = true; 
      // 👉 added: start loader
    });

    final result = await authRegister.registerMe({
      "email": email,
      "username": username,
      "first_name": firstName,
      "last_name": lastName,
      "dob": dob,
      "phone": phone,
      "password": password,
    }); 
    // 👉 added: API call with Map

    setState(() => isLoading = false); 
    // 👉 added: stop loader

    if (result["success"] == true) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      setState(() => errorMsg = result["message"]);
      // 👉 added: show backend-safe error
    }
  }

  void _clearError() {
    if (errorMsg != null) {
      setState(() => errorMsg = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SIGN UP")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _field(
              label: "Email",
              enabled: !emailVerified,
              onChanged: (v) {
                setState(() {
                  email = v;
                  errorMsg = null;
                });
              },
            ),

            if (!otpSent)
              ElevatedButton(
                onPressed: email.isEmpty
                    ? null
                    : () {
                        setState(() => otpSent = true);
                      },
                child: const Text("Send OTP"),
              ),

            if (otpSent && !emailVerified)
              _field(
                label: "Enter OTP",
                onChanged: (v) {
                  setState(() => otp = v);
                  _clearError();
                },
              ),

            if (otpSent && !emailVerified)
              ElevatedButton(
                onPressed: otp.length < 4
                    ? null
                    : () {
                        setState(() => emailVerified = true);
                      },
                child: const Text("Verify OTP"),
              ),

            if (emailVerified)
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "✅ Email Verified",
                  style: TextStyle(color: Colors.green),
                ),
              ),

            if (emailVerified) ...[
              _field(label: "First Name", onChanged: (v) {
                setState(() => firstName = v);
                _clearError();
              }),
              _field(label: "Last Name", onChanged: (v) {
                setState(() => lastName = v);
                _clearError();
              }),
              _field(label: "Create Username", onChanged: (v) {
                setState(() => username = v);
                _clearError();
              }),
              _field(label: "Date of Birth", onChanged: (v) {
                setState(() => dob = v);
                _clearError();
              }),
              _field(label: "Phone Number", onChanged: (v) {
                setState(() => phone = v);
                _clearError();
              }),
              _field(
                label: "Password",
                obscure: true,
                onChanged: (v) {
                  setState(() => password = v);
                  _clearError();
                },
              ),
              _field(
                label: "Re-Password",
                obscure: true,
                onChanged: (v) {
                  setState(() => repassword = v);
                  _clearError();
                },
              ),

              if (errorMsg != null)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    errorMsg!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: isLoading ? null : _signUp,
                // 👉 added: disable button while loading
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Create Account"),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String label,
    required Function(String) onChanged,
    bool enabled = true,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: TextField(
        enabled: enabled,
        obscureText: obscure,
        cursorColor: Colors.blue,
        decoration: InputDecoration(labelText: label),
        onChanged: onChanged,
      ),
    );
  }
}
