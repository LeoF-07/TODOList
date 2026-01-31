import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/tasks_provider.dart';
import 'package:todo_list/utils.dart';

// Mostra le statistiche generali
class StatsPage extends StatelessWidget{
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasksProvider>(context);
    List lists = provider.lists;
    int totalTasks = provider.numberOfTasks;
    int totalCompletedTasks = provider.completedTasks;
    int tasksToSolve = totalTasks - totalCompletedTasks;
    String percentage = (totalCompletedTasks / totalTasks * 100).toStringAsFixed(1);

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
                Icon(Icons.circle, size: 10.w, color: Utils.pointColor),
                SizedBox(width: 5.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Text(
                      provider.lists[i].name,
                      style: (numberOfTasks == 0 || (completedTasks / numberOfTasks * 100) < 100) ? Utils.textStyle : Utils.completedListTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: numberOfTasks != 0 ? Text('$completedTasks/$numberOfTasks      ${(completedTasks / numberOfTasks * 100).toStringAsFixed(1)}%', style: Utils.textStyle) : Text('Empty List'),
                    ),
                  ),
                ),
              ],
            ),
          )
      );
    }

    if(totalTasks == 0){
      return Align(alignment: Alignment.topCenter, child: Padding(padding: EdgeInsets.only(top: 330.h), child: Text("Add a task in a list to view stats")));
    }

    return Column(
      children: [
        Utils.generalStats(totalTasks, totalCompletedTasks, tasksToSolve, percentage),
        Align(
          alignment: Alignment.center,
          child: Text("Overview", style: Utils.textStyle),
        ),
        Container(
          constraints: BoxConstraints(maxHeight: 480.h),
          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Utils.statsBorderColor), borderRadius: BorderRadius.circular(10.w), color: Utils.statsColor),
          child: Column(
              children: rowLists
          )
        )
      ],
    );
  }

}