import 'package:flutter/material.dart';


class LoginTextField extends StatelessWidget {
  LoginTextField({this.height, this.width, this.hint, this.controller});
  final height;
  final width;
  final hint;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            autofillHints: const [AutofillHints.email],
            keyboardType: TextInputType.emailAddress,
            controller: controller,

              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "$hint",
              ),
              cursorColor: Colors.black,
              maxLines: 1),
        ),
      ),
    );
  }
}
