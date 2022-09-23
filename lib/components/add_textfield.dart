import 'package:flutter/material.dart';

class AddTextField extends StatelessWidget {
  AddTextField({this.title,this.width,this.height,this.controller});
  final title;
  final width;
  final height;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title"),
        SizedBox(height: 5,),
        Container(
          height: height,
          width: width,
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  cursorColor: Colors.black,
                  maxLines: 1),
            ),
          ),
        ),
      ],
    );
  }
}
