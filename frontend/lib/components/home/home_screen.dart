import 'package:flutter/material.dart';
import '../../shared/app_drawer.dart';
import 'userDetails_.dart';
import 'intent_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(title: const Text("INTENTRA ")), 
      appBar:AppBar(title:const UserName(),),
      drawer: const AppDrawer(),
      body: const Center(
        child:  IntentraDashboard (),
      ),
    );
  }
}
