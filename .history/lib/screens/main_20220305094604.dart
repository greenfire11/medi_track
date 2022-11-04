// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medi_track/screens/add_screen.dart';
import 'package:medi_track/components/background.dart';
import 'package:medi_track/components/calendar_button.dart';
import 'package:medi_track/components/medicine_container.dart';
import 'package:medi_track/screens/welcome_screen.dart';
import '../constats.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List med = ["Medicine A", "Medicine B", "Medicine C", "Medicine D"];

  void onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Full screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

// Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    double height1 = height - padding.top - padding.bottom;

// Height (without status bar)
    double height2 = height - padding.top;

// Height (without status and toolbar)
    double height3 = height - padding.top - kToolbarHeight;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddScreen()),
        );
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today), label: 'Calendar')
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                onItemSelected(index);
              },
            ),
          ),
        ),
        appBar: PreferredSize(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 15, right: 15, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Medicines",
                                style: kTitleDecoration,
                              ),
                              Text(
                                "Reminder",
                                style: kTitleDecoration,
                              )
                            ],
                          ),
                          Icon(Icons.settings)
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "October",
                        style: kMonthText,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CalendarButton(
                            weekday: "Mon",
                            date: "7",
                            color: Colors.grey,
                          ),
                          CalendarButton(
                            weekday: "Tue",
                            date: "8",
                            color: Colors.grey,
                          ),
                          CalendarButton(
                            weekday: "Wed",
                            date: "9",
                            color: Colors.blue,
                          ),
                          CalendarButton(
                            weekday: "Thu",
                            date: "10",
                            color: Colors.grey,
                          ),
                          CalendarButton(
                            weekday: "Fri",
                            date: "11",
                            color: Colors.grey,
                          ),
                          CalendarButton(
                            weekday: "Sat",
                            date: "12",
                            color: Colors.grey,
                          ),
                          CalendarButton(
                            weekday: "Sun",
                            date: "13",
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            preferredSize: Size.fromHeight(height3 / 5 * 1.7)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.transparent,
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 30);
                  },
                  padding: EdgeInsets.fromLTRB(15, 25, 15, 45),
                  itemCount: med.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          /// edit item
                          return false;
                        } else if (direction == DismissDirection.startToEnd) {
                          setState(() {
                            med.removeAt(index);
                          });
                          /// delete
                          return true;
                          
                        }
                      },
                      background: slideRight(),
                      secondaryBackground: slideLeft(),
                      key: Key(med[index]),
                      child: MedicineCard(
                        image: "pills",
                        name: "${med[index]}",
                        time: "12:00",
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
