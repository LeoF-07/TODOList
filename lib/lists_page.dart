import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_list/page_to_show_provider.dart';
import 'package:todo_list/tasks_page.dart';
import 'package:todo_list/tasks_provider.dart';
import 'package:provider/provider.dart';

class ListsPage extends StatelessWidget{
  const ListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lists = Provider.of<TasksProvider>(context).lists;

    List<Container> buttonLists = [];
    for(int i = 0; i < lists.length; i++){
      buttonLists.add(Container(
        margin: EdgeInsets.all(5.w),
        width: 30.w,
        height: 100.h,
        decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Colors.blue), borderRadius: BorderRadius.circular(10.w)),
        child: GestureDetector(
            onTap: () => context.read<PageToShowProvider>().showTasks(i, lists[i].name),
            child: Padding(
                padding: EdgeInsets.only(top: 10.h, left: 10.w),
                child: Text(lists[i].name))
        )),
      );
    }

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 520.h),
        child: GridView.count(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          crossAxisCount: 3,
          children: buttonLists,
        ),
      )
    );
  }

    /*List<TableRow> rows = [];
    int numberOfListPerRow = 3;
    int j = 0;
    for(int i = 0; i < (lists.length / numberOfListPerRow).floor(); i++, j += numberOfListPerRow){
      rows.add(TableRow(children: buttonLists.sublist(j, j + numberOfListPerRow)));
    }
    List<Container> lastRow = buttonLists.sublist(j, j + lists.length % numberOfListPerRow);
    while(lastRow.length < numberOfListPerRow){
      lastRow.add(Container());
    }
    rows.add(TableRow(children: lastRow));*/

}