import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleStatsPage extends StatelessWidget{
  const SingleStatsPage({super.key, required this.index, required this.name});

  final int index;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(minHeight: 600.h),
          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h),
          margin: EdgeInsets.only(top: 20.h),
          decoration: BoxDecoration(border: BoxBorder.all(width: 2.w, color: Colors.blue), borderRadius: BorderRadius.circular(10.w)),
          child: GridView.count(
            crossAxisCount: 3,
            children: [],
          ),
        )
      ],
    );
  }

}