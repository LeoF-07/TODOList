import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/page_to_show_provider.dart';
import 'package:todo_list/tasks_provider.dart';

class TasksPage extends StatelessWidget{
  const TasksPage({super.key, required this.index, required this.name});
  final int index;
  final String name;

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
            margin: EdgeInsets.symmetric(vertical: 10.h),
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
                        child: GestureDetector(
                          onTap: () {}, // alert con i dettagli
                          child: Text(tasks[i].description, overflow: TextOverflow.ellipsis),
                        )
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
          )
      );
    }

    return SafeArea(
        child: Stack(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 600.h),
              child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100.sw,
                        height: 100.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back_rounded, size: 30.w),
                                    onPressed: () => context.read<PageToShowProvider>().showLists(),
                                  ),
                                )
                            ),
                            Container(
                              width: 200.w, // = double.infinity
                              margin: EdgeInsets.symmetric(vertical: 20.h),
                              decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Colors.blue), borderRadius: BorderRadius.circular(10.w)),
                              child: Center(child: Text(name)),
                            )
                          ],
                        ),
                      ),
                      ...rowTasks
                    ],
                  )
              ),
            ),
            Positioned(
              bottom: 50.h,
              right: 40.w,
              child: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add),
              ),
            )
          ],
        )
    );
  }

}