import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/page_to_show_provider.dart';
import 'package:todo_list/tasks_provider.dart';
import 'package:todo_list/utils.dart';

class TasksPage extends StatelessWidget{
  const TasksPage({super.key, required this.index, required this.name});
  final int index;
  final String name;

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
  }

  void showDetails(BuildContext context, String description, int index){
    final pageContext = context;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text("Task"),
          content: SingleChildScrollView(
            child: Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // chiude il dialog dei dettagli
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Utils.askConfirm(context, "Sei sicuro di voler cancellare questa task?", () => pageContext.read<TasksProvider>().deleteATask(index, this.index));
                });
              },
              child: Text("Elimina", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Chiudi"),
            ),
          ],
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasksProvider>(context);
    final tasks = provider.lists[index].tasks;

    List<Container> rowTasks = [];
    for(int i = 0; tasks != null && i < tasks.length; i++){
      rowTasks.add(
          Container(
            width: 1.sw,
            height: 70.h,
            margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
            decoration: BoxDecoration(
              border: Border.all(width: 2.w, color: Utils.taskBorderColor),
              borderRadius: BorderRadius.circular(10.w),
              color: Utils.taskColor,
            ),
            child: InkWell(
              onTap: () => showDetails(context, tasks[i].description, i),
              borderRadius: BorderRadius.circular(10.w),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Text(
                        tasks[i].description,
                        style: Utils.textStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: IgnorePointer(
                      ignoring: tasks[i].isCompleted,
                      child: IconButton(
                        icon: tasks[i].isCompleted ? Icon(Icons.check_box_rounded) : Icon(Icons.check_box_outline_blank_rounded),
                        onPressed: () => provider.completeTask(listIndex: index, taskIndex: i,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )

      );
    }

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              width: 1.sw,
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
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Colors.black), borderRadius: BorderRadius.circular(10.w), color: Colors.white),
                    child: Center(child: Text(name, style: Utils.textStyle, overflow: TextOverflow.ellipsis,)),
                  ),
                ],
              ),
            ),
            rowTasks.isNotEmpty ? Container(
              constraints: BoxConstraints(minHeight: 500.h),
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                  border: BoxBorder.all(width: 2.w, color: Colors.black),
                  borderRadius: BorderRadius.circular(10.w),
              ),
              child: SingleChildScrollView(
                child: Column(
                    children: rowTasks
                ),
              ),
            ) : SizedBox()
          ],
        ),
        rowTasks.isEmpty ? Positioned(top: 330.h, left: 130.w, child: Text("There is nothing here...", style: Utils.textStyle)) : SizedBox(),
        Positioned(
          bottom: 50.h,
          right: 40.w,
          child: FloatingActionButton(
            backgroundColor: Utils.floatingButtonColor,
            onPressed: () => addATask(context),
            child: Icon(Icons.add),
          ),
        )
      ],
    );
  }

}