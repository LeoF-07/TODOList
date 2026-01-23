import 'package:flutter/material.dart';
import 'package:todo_list/list_of_tasks.dart';

class TasksProvider extends ChangeNotifier{
  List<ListOfTasks> lists = [
    ListOfTasks(name: "Default"),
    ListOfTasks(name: "A"),
    ListOfTasks(name: "B"),
    ListOfTasks(name: "C"),
    ListOfTasks(name: "D"),
    ListOfTasks(name: "E"),
    ListOfTasks(name: "F"),
    ListOfTasks(name: "G"),
    ListOfTasks(name: "H"),
    ListOfTasks(name: "I"),
  ];
}