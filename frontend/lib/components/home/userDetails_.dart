import "package:flutter/material.dart";
import 'package:frontend/core/services/accessusername_service.dart';

class UserName extends StatefulWidget {
  const UserName({super.key});

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  String username = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchMyName();
  }

  Future<void> _fetchMyName() async {
    try {
      final name = await UserNameFetch().fetchUserName();
      if (!mounted) return;
      setState(() {
        username = name ?? "Guest";
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        username = "Guest";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Hi, $username 👋",
      style: const TextStyle(fontSize: 18),
    );
  }
}
