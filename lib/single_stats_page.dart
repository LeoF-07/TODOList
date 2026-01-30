import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/task.dart';
import 'package:todo_list/tasks_provider.dart';
import 'package:todo_list/utils.dart';

class SingleStatsPage extends StatelessWidget{
  const SingleStatsPage({super.key, required this.index, required this.name});

  final int index;
  final String name;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasksProvider>(context);
    List lists = provider.lists;
    int totalTasks = provider.mapNumberOfTasks[lists[index].name]!;
    int completedTasks = provider.mapCompletedTasks[lists[index].name]!;
    int tasksToSolve = totalTasks - completedTasks;
    String percentage = (completedTasks / totalTasks * 100).toStringAsFixed(1);

    final tasks = provider.lists[index].tasks;
    List<Widget> rowTasks = [];
    for (int i = 0; tasks != null && i < tasks.length; i++) {
      if (tasks[i].isCompleted) {
        continue;
      }
      rowTasks.add(
          Container(
            width: 1.sw,
            height: 30.h,
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: Row(
              children: [
                SizedBox(width: 5.w),
                Icon(Icons.circle, size: 10.w, color: Utils.pointColor),
                SizedBox(width: 5.w),
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
              ],
            ),
          )
      );
    }

    if(totalTasks == 0){
      return Align(alignment: Alignment.topCenter, child: Padding(padding: EdgeInsets.only(top: 330.h), child: Text("Add a task to view stats")));
    }
    else if(rowTasks.isNotEmpty){
      return Column(
        children: [
          Utils.generalStats(totalTasks, completedTasks, tasksToSolve, percentage),
          Align(
            alignment: Alignment.center,
            child: Text("Tasks to solve", style: Utils.textStyle,),
          ),
          Container(
              constraints: BoxConstraints(maxHeight: 480.h),
              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Utils.statsBorderColor), borderRadius: BorderRadius.circular(10.w), color: Utils.statsColor),
              child: Column(
                  children: rowTasks
              )
          )
        ],
      );
    }
    else{
      return Center(
        child: Container(
            width: 1.sw,
            padding: EdgeInsets.all(10.w),
            margin: EdgeInsets.only(top: 250.h, bottom: 350.h, left: 70.w, right: 70.w),
            decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Utils.statsBorderColor), borderRadius: BorderRadius.circular(10.w), color: Utils.statsColor),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.h,
                  children: [
                    Text('Total Tasks:', style: Utils.textStyle,),
                    Text('Completed Tasks:', style: Utils.textStyle,),
                    Text('Tasks to solve:', style: Utils.textStyle,),
                    Text('Percentage:', style: Utils.textStyle,),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 10.h,
                    children: [
                      Text(totalTasks.toString(), style: Utils.textStyle,),
                      Text(completedTasks.toString(), style: Utils.textStyle,),
                      Text(tasksToSolve.toString(), style: Utils.textStyle,),
                      Text('$percentage%', style: Utils.textStyle,)
                    ],
                  ),
                ),
              ],
            )
        )
      );
    }

  }

}