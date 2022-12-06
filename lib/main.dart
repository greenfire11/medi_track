// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medi_track/screens/change_password_screen.dart';
import 'package:medi_track/screens/homepage_screen.dart';
import 'package:medi_track/screens/welcome_screen.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:timezone/timezone.dart';
import 'package:url_launcher/url_launcher.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print(FirebaseAuth.instance.currentUser);
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  tz.initializeTimeZones();
  runApp(MyApp(
  ));
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = Locale.fromSubtags(languageCode: 'fr');
  var _dropdownvalue = "fr";

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  void getLocal() async {
    final lang = await SharedPreferences.getInstance();
    if (lang.containsKey('lang') == false) {
      Future<PermissionStatus> permissionStatus = NotificationPermissions.requestNotificationPermissions();


      if (Platform.localeName.split('_')[0] == "fr") {
        await lang.setString("lang", "fr");
      } else {
        await lang.setString("lang", "en");
      }
    }

    setLocale(Locale.fromSubtags(languageCode: '${lang.getString('lang')}'));
    setState(() {
      _dropdownvalue = "${lang.getString('lang')}";
    });
  }

  @override
  void initState() {
    super.initState();

    getLocal();
    print(Platform.localeName.split('_')[0]);
  }

  Widget build(BuildContext context) {
     SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
      supportedLocales: L10n.all,
      locale: _locale,

      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null
          ? MyHomePage2()
          : WelcomeScreen(),
        
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var items = ["en", "fr"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 0.5),
                  ),
                ),
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.account,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                    );
                  
                  
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      SizedBox(
                    height: 20,
                  ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.pass,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 15,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  launchUrl(Uri.parse("https://github.com/greenfire11/medi_track"));
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.priv,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 15,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 0.5),
                  ),
                ),
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Notification",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  AppSettings.openNotificationSettings();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Notifications",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 15,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 0.5),
                  ),
                ),
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.more,
                      size: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.more,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.lang,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  DropdownButton(
                      value: MyApp.of(context)?._dropdownvalue,
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          child: Text(items),
                          value: items,
                        );
                      }).toList(),
                      onChanged: (String? newValue) async {
                        final lang = await SharedPreferences.getInstance();
                        await lang.setString('lang', '$newValue');
                        MyApp.of(context)?.setLocale(
                            Locale.fromSubtags(languageCode: "$newValue"));

                        setState(() {
                          MyApp.of(context)?._dropdownvalue = newValue!;
                        });
                      })
                ],
              ),
              SizedBox(
                height: 70,
              ),
              TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.logout))
            ],
          ),
        ),
      ),
    );
  }
}
