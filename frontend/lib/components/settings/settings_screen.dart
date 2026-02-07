import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'my_settings.dart';

class SettingsScreen extends StatelessWidget{
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(title:const Text("")),
      body:const MySettings(),

    );
  }
}