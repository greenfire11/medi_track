import 'package:flutter/material.dart';

class MedicineType extends StatelessWidget {
  MedicineType({this.image});
  final image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset("images/$image"),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
