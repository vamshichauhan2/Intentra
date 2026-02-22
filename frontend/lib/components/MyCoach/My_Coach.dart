import 'package:flutter/material.dart';
import '../../shared/app_drawer.dart';
import 'TodoList_storage.dart';


class   MyCoach extends StatelessWidget{
  const MyCoach({super.key});


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(title:Text("Hey I am Ready For You"),),
      drawer: const AppDrawer(),
      body: const Center(
        child:  MyTodoHelper(),
      ),


    );
  }
}