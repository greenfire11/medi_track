// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medi_track/screens/add_screen.dart';
import 'package:medi_track/components/background.dart';
import 'package:medi_track/components/calendar_button.dart';
import 'package:medi_track/components/medicine_container.dart';
import 'package:medi_track/screens/welcome_screen.dart';
import 'constats.dart';
import 'l10n/l10n.dart';  
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: L10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
