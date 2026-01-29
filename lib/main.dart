import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/page_to_show_provider.dart';
import 'package:todo_list/single_stats_page.dart';
import 'package:todo_list/stats_page.dart';
import 'package:todo_list/lists_page.dart';
import 'package:todo_list/tasks_page.dart';
import 'package:todo_list/tasks_provider.dart';

void main() async {
  /*runApp(
    ChangeNotifierProvider(
      create: (_) => TasksProvider(),
      child: const MyApp(),
    )
  );*/

  await Hive.initFlutter();
  await Hive.openBox("todoBox");

  /*WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('todoBox');
  Hive.box('todoBox').clear();*/

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TasksProvider()),
        ChangeNotifierProvider(create: (_) => PageToShowProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(412, 915),
      builder: (_, child) => MaterialApp (
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: child
      ),
      child: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PageToShowProvider>(context);
    String page = provider.page;
    int? listIndex = provider.index;
    String? listName = provider.listName;

    List<Tab> tabs = [
      Tab(text: page),
      Tab(text: "Stats")
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: tabs,
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: page == "Lists" ? [
              ListsPage(),
              StatsPage()
            ] : [
              TasksPage(index: listIndex!, name: listName!),
              SingleStatsPage(index: listIndex!, name: listName!)
            ]
            /*[
              page == "Lists" ? ListsPage() : TasksPage(index: listIndex!, name: listName!),
              page == "Lists" ? StatsPage() : SingleStatsPage(index: listIndex!, name: listName!)
            ],*/
          ),
        ),
      ),
    );
  }
}
