import 'package:todo_list/task.dart';

// Classe che rappresenta una Lista di Tasks
class ListOfTasks{
  ListOfTasks({required this.id, required this.name, this.tasks});
  int id;
  String name;
  List<Task>? tasks;

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "tasks": tasks?.map((t) => t.toMap()).toList()
  };

  factory ListOfTasks.fromMap(Map<dynamic, dynamic> map) => ListOfTasks(
    id: map["id"],
    name: map["name"],
    tasks: (map["tasks"] as List?)?.map((t) => Task.fromMap(t)).toList()
  );
}