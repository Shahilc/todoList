import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/features/todo/viewmodel/todo_viewmodel.dart';

import '../../shared/styles/app_colors.dart';

class Builddayselector extends StatelessWidget {
  final HomeProvider vm;
  const Builddayselector( {super.key, required this.vm,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: vm.daysOfMonth.length,
        itemBuilder: (context, index) {
          final isSelected = index == vm.selectedDayIndex;
          final weekday = vm.daysOfWeek[vm.daysOfMonth[index].weekday % 7];
          final day = vm.daysOfMonth[index].day.toString();
          return Container(
            width: 55,
            margin: const EdgeInsets.symmetric(horizontal: 7.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.black
                  : AppColors.customAppbarColor.withOpacity(0.30),
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  weekday,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  day,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
