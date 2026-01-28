import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/list_of_tasks.dart';
import 'package:todo_list/task.dart';

class TasksProvider extends ChangeNotifier{
  TasksProvider() {
    loadLists();
  }

  List<ListOfTasks> lists = [];
  int id = 0;

  bool addAList(String name, {List<Task>? tasks}){
    for(ListOfTasks list in lists){
      if(list.name == name){
        return false;
      }
    }
    lists.insert(0, ListOfTasks(id: id, name: name, tasks: tasks));
    id++;
    saveList(0);
    notifyListeners();
    return true;
  }

  void deleteAList(int index){
    final box = Hive.box('todoBox');
    box.delete(lists[index].name);
    lists.removeAt(index);
    notifyListeners();
  }

  void saveLists() {
    final box = Hive.box('todoBox');
    for(var list in lists){
      box.put(list.name, list.toMap());
    }
  }

  void saveList(int index){
    final box = Hive.box('todoBox');
    box.put(lists[index].name, lists[index].toMap());
  }

  void loadLists() {
    final box = Hive.box('todoBox');

    if (box.isEmpty) {
      addAList("Default", tasks: [
        Task(description: "Clean the bedroom"),
        Task(description: "Do the laundry")
      ]);
      addAList("A");
      addAList("B");
      saveLists();
    } else {
      lists = box.values.map((m) => ListOfTasks.fromMap(m as Map)).toList();
      lists.sort((a, b) => b.id.compareTo(a.id));
    }
    id = lists.last.id + 1;
    notifyListeners();
  }


  void completeTask({required int listIndex, required int taskIndex}){
    lists[listIndex].tasks![taskIndex].complete();
    saveList(listIndex);
    notifyListeners();
  }
}

/*class TasksProvider extends ChangeNotifier{
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
}*/