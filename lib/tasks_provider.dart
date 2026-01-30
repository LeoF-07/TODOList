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

  int numberOfTasks = 0;
  int completedTasks = 0;

  Map<String, int> mapNumberOfTasks = {};
  Map<String, int> mapCompletedTasks = {};

  bool addATask(int index, String description, {force = false}){
    if(lists[index].tasks == null){
      lists[index].tasks = [];
    }

    if(!force){
      for(Task task in lists[index].tasks!){
        if(task.description == description){
          return false;
        }
      }
    }

    lists[index].tasks!.add(Task(description: description));
    numberOfTasks++;
    mapNumberOfTasks[lists[index].name] = mapNumberOfTasks[lists[index].name]! + 1;
    saveList(index);
    notifyListeners();
    return true;
  }

  bool renameList(String name, int index){
    for(ListOfTasks list in lists){
      if(list.name == name){
        return false;
      }
    }

    int oldNumberOfTasks = mapNumberOfTasks[lists[index].name]!;
    int oldCompletedTasks = mapCompletedTasks[lists[index].name]!;
    mapNumberOfTasks.remove(lists[index].name);
    mapCompletedTasks.remove(lists[index].name);

    lists[index].name = name;

    mapNumberOfTasks[lists[index].name] = oldNumberOfTasks;
    mapCompletedTasks[lists[index].name] = oldCompletedTasks;

    notifyListeners();
    return true;
  }

  bool addAList(String name, {List<Task>? tasks}){
    for(ListOfTasks list in lists){
      if(list.name == name){
        return false;
      }
    }
    lists.insert(0, ListOfTasks(id: id, name: name, tasks: tasks));
    id++;
    saveList(0);
    mapNumberOfTasks[lists[0].name] = 0;
    mapCompletedTasks[lists[0].name] = 0;
    notifyListeners();
    return true;
  }

  void deleteAList(int index){
    final box = Hive.box('todoBox');
    box.delete(lists[index].name);
    numberOfTasks -= mapNumberOfTasks[lists[index].name]!;
    completedTasks -= mapCompletedTasks[lists[index].name]!;
    mapNumberOfTasks.remove(lists[index].name);
    mapCompletedTasks.remove(lists[index].name);
    lists.removeAt(index);
    notifyListeners();
  }

  void deleteATask(int index, int listIndex){
    numberOfTasks--;
    mapNumberOfTasks[lists[listIndex].name] = mapNumberOfTasks[lists[listIndex].name]! - 1;
    if(lists[listIndex].tasks![index].isCompleted){
      completedTasks--;
      mapCompletedTasks[lists[listIndex].name] = mapCompletedTasks[lists[listIndex].name]! - 1;
    }
    lists[listIndex].tasks!.removeAt(index);
    saveList(listIndex);
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
      addAList("List 1");
      saveLists();
    } else {
      lists = box.values.map((m) => ListOfTasks.fromMap(m as Map)).toList();
      lists.sort((a, b) => b.id.compareTo(a.id));
    }
    id = lists.last.id + 1;

    for(int i = 0; i < lists.length; i++){
      int numberOfTasks = lists[i].tasks?.length ?? 0;
      int completedTasks = 0;
      this.numberOfTasks += numberOfTasks;
      if(lists[i].tasks != null){
        for(Task task in lists[i].tasks!){
          if(task.isCompleted){
            completedTasks++;
          }
        }
      }
      this.completedTasks += completedTasks;
      mapNumberOfTasks[lists[i].name] = numberOfTasks;
      mapCompletedTasks[lists[i].name] = completedTasks;
    }

    notifyListeners();
  }

  void completeTask({required int listIndex, required int taskIndex}){
    lists[listIndex].tasks![taskIndex].complete();
    saveList(listIndex);
    completedTasks++;
    mapCompletedTasks[lists[listIndex].name] = mapCompletedTasks[lists[listIndex].name]! + 1;
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