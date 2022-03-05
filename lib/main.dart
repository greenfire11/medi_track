// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medi_track/screens/add_screen.dart';
import 'package:medi_track/components/background.dart';
import 'package:medi_track/components/calendar_button.dart';
import 'package:medi_track/components/medicine_container.dart';
import 'package:medi_track/screens/welcome_screen.dart';
import 'constats.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
