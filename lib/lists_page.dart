import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_list/page_to_show_provider.dart';
import 'package:todo_list/tasks_page.dart';
import 'package:todo_list/tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/utils.dart';

class ListsPage extends StatefulWidget{
  const ListsPage({super.key});

  @override
  State<StatefulWidget> createState() => ListsPageState();

}

class ListsPageState extends State<ListsPage>{

  Icon largeGrid = Icon(Icons.grid_on_sharp);
  Icon smallGrid = Icon(Icons.grid_view);
  int iconUsed = 0;

  void changeIcon(){
    setState(() {
      iconUsed = 1 - iconUsed;
    });
  }

  void deleteAList(BuildContext context, int index) {
    Utils.askConfirm(context, "Sei sicuro di voler cancellare questa lista?", () => context.read<TasksProvider>().deleteAList(index));
  }

  void addAList(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    bool isError = false;
    String label = "Nome della lista";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Nuova lista"),
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
                    final name = controller.text.trim();

                    if (name.isEmpty) {
                      setState(() => isError = true);
                      return;
                    }else{
                      if(!context.read<TasksProvider>().addAList(name)){
                        setState(() {isError = true; label = "Lista già esistente"; controller.text = "";});
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

  @override
  Widget build(BuildContext context) {
    final lists = Provider.of<TasksProvider>(context).lists;

    List<GestureDetector> buttonLists = [];
    for(int i = 0; i < lists.length; i++){
      buttonLists.add(
          GestureDetector(
              onTap: () => context.read<PageToShowProvider>().showTasks(i, lists[i].name),
              child: Container(
                padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                margin: EdgeInsets.all(5.w),
                width: 30.w,
                height: 100.h,
                decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Utils.listBorderColor), borderRadius: BorderRadius.circular(10.w), color: Utils.listColor),

                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            lists[i].name,
                            style: Utils.textStyle,
                            maxLines: iconUsed == 0 ? 2 : 4,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 1.h,
                      right: -10.w,
                      //child: IconButton(onPressed: () => deleteAList(context, i), icon: Icon(Icons.dangerous_outlined)),
                      child: IconButton(onPressed: () => deleteAList(context, i), icon: Icon(Icons.close)),
                    )
                  ],
                ),


              )
          )
      );
    }

    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 600.h),
          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
          margin: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
          decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Colors.black), borderRadius: BorderRadius.circular(10.w)),
          child: GridView.count(
            crossAxisCount: iconUsed == 0 ? 3 : 2,
            children: buttonLists,
          ),
        ),
        Positioned(
          bottom: 50.h,
          right: 110.w,
          child: FloatingActionButton(
            onPressed: changeIcon,
            backgroundColor: Colors.white,
            child: iconUsed == 0 ? smallGrid : largeGrid,
          ),
        ),
        Positioned(
          bottom: 50.h,
          right: 40.w,
          child: FloatingActionButton(
            onPressed: () => addAList(context),
            backgroundColor: Colors.white,
            child: Icon(Icons.add),
          ),
        )
      ],
    );
  }

}