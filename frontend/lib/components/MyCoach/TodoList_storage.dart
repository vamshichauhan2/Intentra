import 'package:flutter/material.dart'; 
import '../../core/services/add_Todo_api.dart';
import '../../core/services/FetchMyTodos.dart';
class MyTodoHelper extends StatefulWidget{ 
  const MyTodoHelper({super.key}); 
  @override State<MyTodoHelper> createState() => _MyTodoState(); 
}
class _MyTodoState extends State<MyTodoHelper>{ 
  List<dynamic> todos = [];
  bool loading=true;

  @override
   void initState() {
    super.initState();
    _loadTodaysTodos();
  }
  Future<void> _loadTodaysTodos() async {
  final result = await FetchTodaysTodo().getMyTodaysTodo();
  if (!mounted) return;

  setState(() {
    todos = result;
    loading = false;
  });
}

  void _openAddTaskForm(){
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    bool todayTarget = false;
    int priority = 5;

    showModalBottomSheet(
    context: context, 
    isScrollControlled: true,
    builder:(context){
      return Padding(
        padding:EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
        child:Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children: [
            const Text(
            "Add Task",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Task"),
              ),
              TextField(
                controller: timeController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: "Time needed (minutes)"),
              ),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Today Target"),
                  Switch(
                    value: todayTarget,
                    onChanged: (val) {
                      todayTarget = val;
                    },
                  ),
                ],
              ),

              const Text("Priority (10 = High)"),
              Slider(
                value: priority.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: priority.toString(),
                onChanged: (val) {
                  priority = val.toInt();
                },
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () async {
  await TodoApi.createTask(
    title: titleController.text,
    todayTarget: todayTarget,
    timeNeeded: int.parse(timeController.text),
    priority: priority,
  );

  Navigator.pop(context);
  _loadTodaysTodos(); // 🔥 refresh list
},
                child: const Text("Add Task"),
              ),

             ],)
          );

    },);
  }
  
  @override 
  Widget build(BuildContext context){

     return Scaffold(
      appBar:AppBar(title:const Text("Intentra")),
      body: loading
    ? const Center(child: CircularProgressIndicator())
    : todos.isEmpty
        ? const Center(child: Text("No tasks for today"))
        : ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return ListTile(
                title: Text(todo["title"]),
                subtitle: Text(
                  "⏱ ${todo["timeNeeded"]} min • ⭐ ${todo["priority"]}",
                ),
                trailing: todo["todayTarget"] == true
                    ? const Icon(Icons.flag, color: Colors.red)
                    : null,
              );
            },
          ),
        floatingActionButton: FloatingActionButton( onPressed: _openAddTaskForm, child: const Icon(Icons.add), ),
      ); 
     } 
}