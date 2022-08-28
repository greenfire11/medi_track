// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:medi_track/screens/homepage_screen.dart';
import '../components/background.dart';
import '../components/calendar_button.dart';
import '../components/medicine_container.dart';
import '../constats.dart';
import 'add_screen.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, WeekdayFormat;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  List _dates1 = [];
  
    final FirebaseAuth auth = FirebaseAuth.instance;
  late String userid =auth.currentUser!.uid;
  int _selectedIndex = 0;
  DateFormat format = DateFormat("dd.MM.yyyy");
  DateTime date1 = DateTime.now();
    
  late Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection(userid)
      .where('dates', arrayContainsAny: [
    DateFormat('dd.MM.yyyy').format(date1)
  ]).snapshots(includeMetadataChanges: true);

  List med = ["Medicine A", "Medicine B", "Medicine C", "Medicine D"];
  

  void onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
@override
void initState() {
    super.initState();
    _getCarouselMarkedDates();
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
      child: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return WillPopScope(
                onWillPop: () async => false,
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
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                  bottomNavigationBar: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
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
                          BottomNavigationBarItem(
                            icon: Icon(Icons.home),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.calendar_today), label: 'Calendar')
                        ],
                        currentIndex: 1,
                        onTap: (index) {
                          if (index == 0) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2) =>
                                    MyHomePage2(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                              (route) => false,
                            );
                            onItemSelected(index);
                          }
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
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: CalendarCarousel<Event>(
                            onDayPressed: (DateTime date, List<Event> events) {
                              setState(() {
                                date1 = date;
                                _usersStream = FirebaseFirestore.instance
                                    .collection(userid)
                                    .where('dates', arrayContainsAny: [
                                  DateFormat('dd.MM.yyyy').format(date1)
                                ]).snapshots(includeMetadataChanges: true);
                              });
                            },
                            thisMonthDayBorderColor: Colors.transparent,
                            selectedDayButtonColor: Colors.blue,
                            selectedDayBorderColor: Colors.blue,
                            selectedDayTextStyle: TextStyle(color: Colors.black),
                            weekendTextStyle: TextStyle(color: Colors.black),
                            daysTextStyle: TextStyle(color: Colors.black),
                            nextDaysTextStyle: TextStyle(color: Colors.grey),
                            prevDaysTextStyle: TextStyle(color: Colors.grey),
                            weekdayTextStyle: TextStyle(color: Colors.grey),
                            weekDayFormat: WeekdayFormat.short,
                            firstDayOfWeek: 0,
                            showHeader: true,
                            locale: Localizations.localeOf(context).toString(),
                            isScrollable: true,
                            weekFormat: false,
                            height: 310,
                            selectedDateTime: date1,
                            daysHaveCircularBorder: true,
                            customGridViewPhysics:
                                AlwaysScrollableScrollPhysics(),
                            markedDatesMap: _dates1 == [] ? _getCar() : _getCarouselMarkedDates(),
                            markedDateWidget: Container(
                              height: 3,
                              width: 3,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      preferredSize: Size.fromHeight(height3 / 5 * 2.2)),
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
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                 direction: DismissDirection.endToStart,
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    if (snapshot.data!.docs[index]['completed'][
                                            snapshot.data!.docs[index]['dates']
                                                .indexOf(DateFormat("dd.MM.yyy")
                                                    .format(date1))] ==
                                        true) {
                                          List boool =
                                          snapshot.data!.docs[index]['dates'];
                                      var ind = boool.indexOf(
                                          DateFormat("dd.MM.yyy")
                                              .format(date1));
                                      var nList = snapshot.data!.docs[index]
                                          ['completed'];
                                      nList[ind] = false;
                                      await FirebaseFirestore.instance
                                          .collection(userid)
                                          .doc(snapshot
                                              .data!.docs[index].reference.id)
                                          .update({'completed': nList});
                                    } else {
                                      List boool =
                                          snapshot.data!.docs[index]['dates'];
                                      var ind = boool.indexOf(
                                          DateFormat("dd.MM.yyy")
                                              .format(date1));
                                      var nList = snapshot.data!.docs[index]
                                          ['completed'];
                                      nList[ind] = true;
                                      await FirebaseFirestore.instance
                                          .collection(userid)
                                          .doc(snapshot
                                              .data!.docs[index].reference.id)
                                          .update({'completed': nList});
                                    }
                                  }
                                },
                                background: snapshot.data!.docs[index]['completed'][
                                      snapshot.data!.docs[index]['dates']
                                          .indexOf(DateFormat("dd.MM.yyy")
                                              .format(date1))]==true ? slideRight() : slideLeft(),
                                key: Key(""),
                                child: MedicineCard(
                                  image: snapshot.data!.docs[index]['image'],
                                  name: snapshot.data!.docs[index]['name'],
                                  time: snapshot.data!.docs[index]['time'],
                                  doc: snapshot.data!.docs[index].reference.id,
                                  done: snapshot.data!.docs[index]['completed'][
                                      snapshot.data!.docs[index]['dates']
                                          .indexOf(DateFormat("dd.MM.yyy")
                                              .format(date1))],
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
            return Scaffold(
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
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
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
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.calendar_today), label: 'Calendar')
                    ],
                    currentIndex: 1,
                    onTap: (index) {
                      if (index == 0) {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                MyHomePage2(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                        onItemSelected(index);
                      }
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
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: CalendarCarousel<Event>(
                        onDayPressed: (DateTime date, List<Event> events) {
                          setState(() {
                            date1 = date;
                          });
                        },
                        thisMonthDayBorderColor: Colors.transparent,
                        selectedDayButtonColor: Colors.blue,
                        selectedDayBorderColor: Colors.blue,
                        selectedDayTextStyle: TextStyle(color: Colors.black),
                        weekendTextStyle: TextStyle(color: Colors.black),
                        daysTextStyle: TextStyle(color: Colors.black),
                        nextDaysTextStyle: TextStyle(color: Colors.grey),
                        prevDaysTextStyle: TextStyle(color: Colors.grey),
                        weekdayTextStyle: TextStyle(color: Colors.grey),
                        weekDayFormat: WeekdayFormat.short,
                        firstDayOfWeek: 0,
                        showHeader: true,
                        locale: Localizations.localeOf(context).toString(),
                        isScrollable: true,
                        weekFormat: false,
                        height: 310,
                        selectedDateTime: date1,
                        daysHaveCircularBorder: true,
                        customGridViewPhysics: AlwaysScrollableScrollPhysics(),
                        markedDatesMap: null,
                        markedDateWidget: Container(
                          height: 3,
                          width: 3,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  preferredSize: Size.fromHeight(height3 / 5 * 2.2)),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      child: Container(),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  void setDates() async{
    FirebaseFirestore.instance
    .collection(userid)
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
            for (var str in doc['dates']) {
              setState(() {
                _dates1.add(format.parse(str));
              });

                
              
              
            }
        });
    });
  

  }

  EventList<Event> _getCarouselMarkedDates()  {
    setDates();

  var dates = _dates1.toSet().toList();

  var eventList=[];
  var eventDayMap2 = <DateTime, List<Event>>{};

  for (var date1 in dates) {
    eventList.add(Event(date:date1));
    
  }
  for (var event in eventList) {
  (eventDayMap2[event.date] ??= []).add(event);
}

    return EventList<Event>(
      events: eventDayMap2
    );
  }
}


EventList<Event> _getCar() {
  return EventList<Event> (events: {

  });
}


