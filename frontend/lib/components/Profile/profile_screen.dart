import 'package:flutter/material.dart';
import 'my_profile.dart';

class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(title:const Text("profile"),),
      body:const MyProfile(),
    );
  }
}