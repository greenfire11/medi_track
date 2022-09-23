import 'package:flutter/material.dart';

class CalendarButton extends StatelessWidget {
  CalendarButton({this.weekday, this.date, this.color,this.funct});
  final weekday;
  final date;
  final color;
  final funct;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(weekday),
        SizedBox(
          height: 3,
        ),
        GestureDetector(
          onTap: funct,
          child: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
              child: Center(child: Text(date)),
            
          ),
        )
      ],
    );
  }
}