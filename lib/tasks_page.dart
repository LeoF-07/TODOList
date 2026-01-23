import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/tasks_provider.dart';

class TasksPage extends StatelessWidget{
  const TasksPage({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final lists = Provider.of<TasksProvider>(context).lists;

    return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 520.h),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              // border: TableBorder.all(),
              children: // tasks
              [
                ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Pop")),
                Text(name)
              ],
            ),
          ),
        )
    );
  }

}