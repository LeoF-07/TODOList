import 'package:todo_list/task.dart';

class ListOfTasks{
  ListOfTasks({required this.name, this.tasks});
  String name;
  List<Task>? tasks;

  Map<String, dynamic> toMap() => {
    "name": name,
    "tasks": tasks?.map((t) => t.toMap()).toList()
  };

  factory ListOfTasks.fromMap(Map<dynamic, dynamic> map) => ListOfTasks(
    name: map["name"],
    tasks: (map["tasks"] as List?)?.map((t) => Task.fromMap(t)).toList()
  );
}