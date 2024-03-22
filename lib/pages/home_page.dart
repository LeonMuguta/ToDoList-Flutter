// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unnecessary_new, prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/database.dart';
import 'package:flutter_todo_app/utilities/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('testBox');

  // Create an instance of the database class
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      // First time logging into the app
      db.createInitialData();
    } else {
      // Getting previously stored data
      db.loadData();
    }

    super.initState();
  }

  TextEditingController _newTaskFieldController = new TextEditingController();

  // Checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDatabase();
  }

  // Remove task from list
  void removeTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
  }

  void saveNewTask() {
    print(_newTaskFieldController.text);
    setState(() {
        db.toDoList.add([_newTaskFieldController.text, false]);
      },
    );
    Navigator.of(context).pop();
    _newTaskFieldController.clear();
    db.updateDatabase();
  }

  // Creation of a new task
  void createNewTask() {
    showDialog(
      context: context, 
      builder: (BuildContext) {
        return AlertDialog(
          backgroundColor: Colors.orange,
          title: Text('New Task', style: TextStyle(color: Colors.black)),
          content: TextField(
            controller: _newTaskFieldController,
            decoration: InputDecoration(hintText: "Task...", border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _newTaskFieldController.clear();
              }, 
              child: Text("Cancel", style: TextStyle(color: Colors.black))
            ),
            TextButton(
              onPressed: saveNewTask,
              child: Text("Confirm", style: TextStyle(color: Colors.black)),
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[600],
      appBar: AppBar(
        title: Text("To Do"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.orange,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.black
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewTask(),
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder:(context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0], 
            taskCompleted: db.toDoList[index][1], 
            onChanged: (value) =>  checkBoxChanged(value, index),
            deleteTask: (context) => removeTask(index),
          );
        },
      ),
    );
  }
}