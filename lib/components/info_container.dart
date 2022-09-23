import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  InfoContainer({this.title,this.info});
  final title;
  final info;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title"),
        SizedBox(height: 5,),
        Container(
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
          height: 38,
          width: 100,
          child: Center(child: Text("$info"),),
        )
      ],
    );
  }
}
