import 'package:flutter/material.dart';

// Provider per la pagina da visualizzare
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
    index = i; // indice della lista nella "lista di liste"
    listName = list; // nome della lista
    notifyListeners();
  }
}