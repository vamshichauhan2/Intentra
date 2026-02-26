import 'package:flutter/material.dart';
import 'dart:ui';

import '../../core/services/add_Todo_api.dart';
import '../../core/services/FetchMyTodos.dart';
import "../../core/services/DeleteByIdTask.dart";

class MyTodoHelper extends StatefulWidget {
  const MyTodoHelper({super.key});

  @override
  State<MyTodoHelper> createState() => _MyTodoState();
}

class _MyTodoState extends State<MyTodoHelper> {
  List<dynamic> todos = [];
  bool loading = true;

  // 🔥 hover state
  int? hoveredIndex;

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

  Future<void>__deleteTaskById(int id) async{
    final result=await DeletebyTaskId().deleteRequestedByTaskId(id);
     if (!result) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to delete")),
    );
    
    return;
  } 
   _loadTodaysTodos();
  }

  void _openAddTaskForm() {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    bool todayTarget = false;
    int priority = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add Task",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
                  _loadTodaysTodos();
                },
                child: const Text("Add Task"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Intentra")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : todos.isEmpty
              ? const Center(child: Text("No tasks for today"))
              : ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];

                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) =>
                          setState(() => hoveredIndex = index),
                      onExit: (_) =>
                          setState(() => hoveredIndex = null),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        transform: Matrix4.identity()
                          ..scale(
                              hoveredIndex == index ? 1.02 : 1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: hoveredIndex == index
                                    ? 16
                                    : 12,
                                sigmaY: hoveredIndex == index
                                    ? 16
                                    : 12,
                              ),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 180),
                                decoration: BoxDecoration(
                                  // 🔥 BG CHANGE ON HOVER
                                  color: hoveredIndex == index
                                      ? const Color.fromARGB(
                                              255, 140, 44, 44)
                                          .withOpacity(0.30)
                                      : const Color.fromARGB(
                                              255, 140, 44, 44)
                                          .withOpacity(0.15),
                                  borderRadius:
                                      BorderRadius.circular(16),
                                  border: Border.all(
                                    color: hoveredIndex == index
                                        ? Colors.white
                                            .withOpacity(0.45)
                                        : Colors.white
                                            .withOpacity(0.25),
                                  ),
                                ),
                                child: ListTile(
                                  leading: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      __deleteTaskById(todo["id"]);
                                    },
                                  ),
                                  title: Text(
                                    todo["title"],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "⏱ ${todo["timeNeeded"]} min • ⭐ ${todo["priority"]}",
                                    style: TextStyle(
                                      color: Colors.black
                                          .withOpacity(0.75),
                                    ),
                                  ),
                                  trailing: todo["todayTarget"] ==
                                          true
                                      ? const Icon(
                                          Icons.flag,
                                          color:
                                              Colors.redAccent,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}