import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/page_to_show_provider.dart';
import 'package:todo_list/tasks_provider.dart';
import 'package:todo_list/utils.dart';

// Mostra l'elenco di task di una lista
class TasksPage extends StatelessWidget{
  const TasksPage({super.key, required this.index, required this.name});
  final int index;
  final String name;

  void addATask(BuildContext context) {
    TextEditingController controller = TextEditingController();
    bool isError = false;
    String label = "Descrizione Task";

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (_, setState) {
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

                    // Se è già presente una task viene mostrato un altro dialog che chiede conferma
                    if (!context.read<TasksProvider>().addATask(index, description)) {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text("Task già esistente"),
                            content: Text(
                              "Esiste già una task con questa descrizione.\nVuoi aggiungerla comunque?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false), // ritorna un booleano dal pop che viene memorizzato su confirm
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
    // Dialog che mostra i dettagli della task e consente anche di eliminarla
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
                  Utils.askConfirm(context, "Sei sicuro di voler cancellare questa task?", () => context.read<TasksProvider>().deleteATask(index, this.index));
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
            // InkWell è utile se si vuole far si che prenda i click sull'intero container ma lasci passare i click a un elemento interno, come l'IconButton sotto
            child: InkWell(
              onTap: () => showDetails(context, tasks[i].description, i),
              borderRadius: BorderRadius.circular(10.w),
              child: Row(
                children: [
                  // Il nome della task occupa tutto lo spazio dispnibile
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Text(
                        tasks[i].description,
                        style: Utils.textStyle,
                        overflow: TextOverflow.ellipsis, // ...
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    // IgnorePointer abbinato a InkWell consente di gestire i click sia del container sia dell'IconButton interno
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
              // Stack che contiene una freccia per tornare indietro e un container con il nome della lista
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
              constraints: BoxConstraints(minHeight: 510.h),
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
        // Devo metterlo qui perché deve stare dentro uno stack
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