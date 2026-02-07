import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MySettings extends StatefulWidget {
  const MySettings({super.key});

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  bool notificationsEnabled = true;

  void _logout(BuildContext context ) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("access_token");
  await prefs.remove("refresh_token");

   Navigator.pushNamedAndRemoveUntil(
  context,
  AppRoutes.login,
  (route) => false,
);

  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold (
      
      body:ListView(children: [
        SwitchListTile(
          title: const Text("Enable Notifications"),
          value: notificationsEnabled,
          onChanged: (value) {
            setState(() {
              notificationsEnabled = value;
            });
          },
        

        ),
        
      ],  
      ),
      floatingActionButton:FloatingActionButton(
          backgroundColor: Colors.green,
        foregroundColor: Colors.white,
         onPressed: () => _logout(context),
          // call usage permission here later
        
        child: const Text("Logout"),
        )
    
    );
  }
}
