import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/page_to_show_provider.dart';
import 'package:todo_list/tasks_provider.dart';

class TasksPage extends StatelessWidget{
  const TasksPage({super.key, required this.index, required this.name});
  final int index;
  final String name;

  /*void addATask(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    bool isError = false;
    String label = "Descrizione Task";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Nuova Task"),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isError ? Colors.red : Colors.grey,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isError ? Colors.red : Colors.blue,
                      width: 2,
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Annulla"),
                ),
                TextButton(
                  onPressed: () {
                    final description = controller.text.trim();

                    if (name.isEmpty) {
                      setState(() => isError = true);
                      return;
                    }else{
                      if(!context.read<TasksProvider>().addATask(name, description)){
                        return;
                      }

                    }
                    Navigator.pop(context);
                  },
                  child: Text("Aggiungi"),
                ),
              ],
            );
          },
        );
      },
    );
  }*/

  void addATask(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    bool isError = false;
    String label = "Descrizione Task";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Nuova Task"),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isError ? Colors.red : Colors.grey,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isError ? Colors.red : Colors.blue,
                      width: 2,
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Annulla"),
                ),
                TextButton(
                  onPressed: () async {
                    final description = controller.text.trim();

                    if (description.isEmpty) {
                      setState(() => isError = true);
                      return;
                    }

                    if (!context.read<TasksProvider>().addATask(index, description)) {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Task già esistente"),
                            content: Text(
                              "Esiste già una task con questa descrizione.\n"
                                  "Vuoi aggiungerla comunque?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text("No"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text("Sì, aggiungi"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        context.read<TasksProvider>().addATask(index, description, force: true);
                      } else {
                        return;
                      }
                    }

                    Navigator.pop(context); // chiude il dialog principale
                  },
                  child: Text("Aggiungi"),
                ),
              ],
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasksProvider>(context);
    final tasks = provider.lists[index].tasks;

    List<GestureDetector> rowTasks = [];
    for(int i = 0; tasks != null && i < tasks.length; i++){
      rowTasks.add(
        GestureDetector(
          onTap: () {},
          child: Container(
              width: 1.sw,
              height: 70.h,
              margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
              decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Colors.blue), borderRadius: BorderRadius.circular(10.w)),
              child: Stack(
                children: [
                  SizedBox(
                    //decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Colors.blue), borderRadius: BorderRadius.circular(10.w)),
                    width: 0.78.sw,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: Text(tasks[i].description, overflow: TextOverflow.ellipsis),
                        )
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: IgnorePointer( // così lascia l'animazione senza far diventare trasparente il pulsante
                              ignoring: tasks[i].isCompleted,
                              child: IconButton(
                                icon: tasks[i].isCompleted ? Icon(Icons.check_box_rounded) : Icon(Icons.check_box_outline_blank_rounded),
                                onPressed: () => provider.completeTask(listIndex: index, taskIndex: i),
                              )
                          )
                      )
                  )
                ],
              )
          ),
        )
      );
    }

    return Stack(
      children: [
              Column(
                children: [
                  SizedBox(
                    width: 100.sw,
                    height: 100.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 10.w,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_rounded, size: 30.w),
                                onPressed: () => context.read<PageToShowProvider>().showLists(),
                              ),
                            )
                        ),
                        Container(
                          width: 200.w,
                          margin: EdgeInsets.symmetric(vertical: 20.h),
                          decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Colors.blue), borderRadius: BorderRadius.circular(10.w)),
                          child: Center(child: Text(name)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(minHeight: 500.h),
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Colors.blue), borderRadius: BorderRadius.circular(10.w)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: rowTasks
                      ),
                    ),
                  )
                ],


        ),
        rowTasks.isEmpty ? Positioned(top: 330.h, left: 130.w, child: Text("There is nothing here...")) : SizedBox(),
        Positioned(
          bottom: 50.h,
          right: 40.w,
          child: FloatingActionButton(
            onPressed: () => addATask(context),
            child: Icon(Icons.add),
          ),
        )
      ],
    );
  }

}