import 'package:flutter/material.dart';

const kTitleDecoration=TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 27
);

const kMonthText=TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 15
);

const kContainerDec=BoxDecoration(color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],);