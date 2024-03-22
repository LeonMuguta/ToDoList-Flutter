import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  // Default tasks at start
  List toDoList = [];

  // Reference the box
  final _myBox = Hive.box('testBox');

  // Run this method if it's the user's first time opening the app
  void createInitialData() {
    toDoList = [
      ["Make food",  true],
      ["Clean Dishes", false],
    ];
  }

  // Load the data from the database
  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  // Update the database
  void updateDatabase() {
    _myBox.put("TODOLIST", toDoList);
  }

}