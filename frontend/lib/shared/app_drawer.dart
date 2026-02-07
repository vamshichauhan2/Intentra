import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../components/settings/settings_screen.dart';
import '../routes/app_routes.dart';


class AppDrawer extends StatelessWidget {
    const AppDrawer({super.key});

   /* void _navigate(BuildContext context, Widget page){
      Navigator.pop(context); // 1️⃣ close drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
    }*/
   void _go(BuildContext context, String route) {
    Navigator.pop(context);              // close drawer
    Navigator.pushNamed(context, route); // navigate
  }


    @override 
    Widget build(BuildContext context){
       
        return Drawer(
        child:ListView(children: [ ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              //onTap: () {
             // Navigator.pop(context);
            //},
                onTap: () => _go(context, AppRoutes.home),
            ),
            ListTile(
              leading: Icon(Icons.lightbulb),
              title:Text("MyIntent"),
              onTap: () => _go(context, AppRoutes.myIntents),
            ),
             ListTile(
              leading: Icon(Icons.history),
              title:Text("Activity TimeLine"),
               onTap: () => _go(context, AppRoutes.timeline),
            ),
             ListTile(
              leading: Icon(Icons.center_focus_strong),
              title:Text("Focus Mode"),
              onTap: () => _go(context, AppRoutes.focus),
            ),
            ListTile(
              leading:Icon(Icons.person),
              title:Text("Profile"),
              onTap: () => _go(context, AppRoutes.profile),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => _go(context, AppRoutes.settings),
              /*onTap:(){
                _navigate(context ,const SettingsScreen());
              },*/
            ),],)
      );

       
    }

}