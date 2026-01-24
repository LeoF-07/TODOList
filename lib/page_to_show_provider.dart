import 'package:flutter/material.dart';

class PageToShowProvider extends ChangeNotifier{
  String page = "Lists";
  int? index;
  String? listName;

  void showLists(){
    page = "Lists";
    notifyListeners();
  }

  void showTasks(int i, String list){
    page = "Tasks";
    index = i;
    listName = list;
    notifyListeners();
  }
}