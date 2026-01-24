import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/list_of_tasks.dart';
import 'package:todo_list/task.dart';

class TasksProvider extends ChangeNotifier{
  /*List<ListOfTasks> lists = [
    ListOfTasks(name: "Default", tasks: [
      Task(description: "Clean the bedroom"),
      Task(description: "Do the laundry")
    ]),
    ListOfTasks(name: "A"),
    ListOfTasks(name: "B"),
    ListOfTasks(name: "C"),
    ListOfTasks(name: "D"),
    ListOfTasks(name: "E"),
    ListOfTasks(name: "F"),
    ListOfTasks(name: "G"),
    ListOfTasks(name: "H"),
    ListOfTasks(name: "I"),
  ];*/

  TasksProvider() {
    loadLists();
  }

  List<ListOfTasks> lists = [];

  void saveLists() {
    final box = Hive.box('todoBox');
    box.put('lists', lists.map((l) => l.toMap()).toList());
  }

  void loadLists() {
    final box = Hive.box('todoBox');

    if (box.isEmpty) {
      lists = [
        ListOfTasks(name: "Default", tasks: [
          Task(description: "Clean the bedroom"),
          Task(description: "Do the laundry")
        ]),
        ListOfTasks(name: "A"),
        ListOfTasks(name: "B"),
      ];
      saveLists();
    } else {
      lists = (box.get('lists') as List).map((m) => ListOfTasks.fromMap(m)).toList();
    }

    notifyListeners();
  }


  void completeTask({required int listIndex, required int taskIndex}){
    lists[listIndex].tasks![taskIndex].complete();
    saveLists();
    notifyListeners();
  }
}