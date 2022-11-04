import 'package:flutter/material.dart';

class CalendarButton extends StatelessWidget {
  CalendarButton({this.weekday, this.date, this.color});
  final weekday;
  final date;
  final color;
  this.func
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(weekday),
        SizedBox(
          height: 3,
        ),
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
            child: Center(child: Text(date)),
          
        )
      ],
    );
  }
}