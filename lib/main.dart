import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/stats_page.dart';
import 'package:todo_list/lists_page.dart';
import 'package:todo_list/tasks_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TasksProvider(),
      child: const MyApp(),
    )
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

  static const List<Tab> tabs = [
    Tab(text: "Liste"),
    Tab(text: "Stats")
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: tabs,
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              ListsPage(),
              StatsPage()
            ],
          ),
        ),
      ),
    );
  }
}
