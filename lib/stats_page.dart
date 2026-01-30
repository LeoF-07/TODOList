import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/tasks_provider.dart';

class StatsPage extends StatelessWidget{
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasksProvider>(context);
    List lists = provider.lists;
    int totalTasks = provider.numberOfTasks;
    int completedTasks = provider.completedTasks;
    int tasksToSolve = totalTasks - completedTasks;
    String percentage = (completedTasks / totalTasks * 100).toStringAsFixed(1);

    List<Widget> rowLists = [];
    for(int i = 0; i < lists.length; i++){
      int numberOfTasks = provider.mapNumberOfTasks[lists[i].name]!;
      int completedTasks = provider.mapCompletedTasks[lists[i].name]!;
      rowLists.add(
          Container(
            width: 1.sw,
            height: 30.h,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              children: [
                SizedBox(width: 5.w),
                Icon(Icons.circle, size: 10.w, color: Colors.blue),
                SizedBox(width: 5.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Text(
                      provider.lists[i].name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: numberOfTasks != 0 ? Text('$completedTasks/$numberOfTasks      ${(completedTasks / numberOfTasks * 100).toStringAsFixed(1)}%',) : Text('Empty List'),
                    ),
                  ),
                ),
              ],
            ),
          )
      );
    }

    return Column(
      children: [
        Container(
            width: 1.sw,
            padding: EdgeInsets.all(10.w),
            margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 70.w),
            decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Colors.blue), borderRadius: BorderRadius.circular(10.w)),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.h,
                  children: [
                    Text('Total Tasks:'),
                    Text('Completed Tasks:'),
                    Text('Tasks to solve:'),
                    Text('Percentage:'),
                  ],
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 10.h,
                    children: [
                      Text(totalTasks.toString()),
                      Text(completedTasks.toString()),
                      Text(tasksToSolve.toString()),
                      Text('$percentage%')
                    ],
                  ),
                ),
              ],
            )
        ),
        Container(
          constraints: BoxConstraints(maxHeight: 500.h),
          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Colors.blue), borderRadius: BorderRadius.circular(10.w)),
          child: Column(
              children: rowLists
          )
        )
      ],
    );
  }

}