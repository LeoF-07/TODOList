import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Classe Utils con alcune cose di comune utilizzo
abstract class Utils{

  static Color listBorderColor = Colors.black;
  static Color listColor = Colors.white;
  static Color taskBorderColor = Colors.black;
  static Color taskColor = Colors.white;
  static Color pointColor = Colors.black;
  static Color floatingButtonColor = Colors.white;
  static Color statsBorderColor = Colors.black;
  static Color statsColor = Colors.white;
  static Color completedListColor = Colors.green;
  static TextStyle completedListTextStyle = TextStyle(fontSize: 14.w, color: Colors.green);
  static TextStyle textStyle = TextStyle(fontSize: 14.w);

  static Container generalStats(int totalTasks, int completedTasks, int tasksToSolve, String percentage){
    return Container(
        width: 1.sw,
        padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 70.w),
        decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Utils.statsBorderColor), borderRadius: BorderRadius.circular(10.w), color: Utils.statsColor),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10.h,
              children: [
                Text('Total Tasks:', style: textStyle),
                Text('Completed Tasks:', style: textStyle,),
                Text('Tasks to solve:', style: textStyle,),
                Text('Percentage:', style: textStyle,),
              ],
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 10.h,
                children: [
                  Text(totalTasks.toString(), style: textStyle,),
                  Text(completedTasks.toString(), style: textStyle,),
                  Text(tasksToSolve.toString(), style: textStyle,),
                  Text('$percentage%', style: textStyle,)
                ],
              ),
            ),
          ],
        )
    );
  }

  static void askConfirm(BuildContext context, String text, Function function){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Conferma eliminazione"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annulla"),
            ),
            TextButton(
              onPressed: () {
                function();
                Navigator.pop(context);
              },
              child: Text(
                "Elimina",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

}