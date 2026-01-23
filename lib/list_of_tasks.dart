import 'package:todo_list/task.dart';

class ListOfTasks{
  ListOfTasks({required this.name, tasks});
  String name;
  List<Task> tasks = [];
}