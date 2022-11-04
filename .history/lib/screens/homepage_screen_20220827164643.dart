import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medi_track/screens/calendar_screen.dart';
import 'package:medi_track/screens/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../components/background.dart';
import '../components/calendar_button.dart';
import '../components/medicine_container.dart';
import '../constats.dart';
import 'add_screen.dart';
import 'package:intl/intl.dart';

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({Key? key}) : super(key: key);
  @override
  _MyHomePage2State createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  DateTime date1 = DateTime.now();
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String userid = auth.currentUser!.uid;
  @override
  DateTime i = DateTime.now();
  late Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection(userid)
      .where('dates', arrayContainsAny: [
    DateFormat('dd.MM.yyyy').format(date1)
  ]).snapshots(includeMetadataChanges: true);
  int _selectedIndex = 0;
  late var formattedDate1 = DateFormat("dd.MM.yyyy").format(date1);
  List med = ["Medicine A", "Medicine B", "Medicine C", "Medicine D"];
  DateTime now = DateTime.now();


  String selectDate(int wday) {
    if (DateTime.now().weekday == wday) {
      return DateTime.now().day.toString();
    } else if (DateTime.now().weekday > wday) {
      return DateTime.now()
          .subtract(Duration(days: DateTime.now().weekday - wday))
          .day
          .toString();
    } else {
      return DateTime.now()
          .add(Duration(days: wday - DateTime.now().weekday))
          .day
          .toString();
    }
  }

  void onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void changeDate(int wday)  async {
    
     if (date1.weekday > wday)   {
       setState(() {
        date1 = date1.subtract(Duration(days: date1.weekday - wday));
        formattedDate1 = DateFormat("dd.MM.yyyy").format(date1);
        _usersStream = FirebaseFirestore.instance
            .collection(userid)
            .where('dates', arrayContainsAny: [
          DateFormat('dd.MM.yyyy')
              .format(date1.subtract(Duration(days: date1.weekday - wday)))
        ]).snapshots(includeMetadataChanges: true);

      });
    } else if (date1.weekday < wday)  {
      setState(() {
        date1 = date1.add(Duration(days: wday - date1.weekday));
        formattedDate1 = DateFormat("dd.MM.yyyy").format(date1);
        _usersStream = FirebaseFirestore.instance
            .collection(userid)
            .where('dates', arrayContainsAny: [
          DateFormat('dd.MM.yyyy')
              .format(date1.add(Duration(days: wday - date1.weekday)))
        ]).snapshots(includeMetadataChanges: true);
      });
      
    }
    
  }

  @override
  @override


  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;


    var padding = MediaQuery.of(context).viewPadding;

    double height3 = height - padding.top - kToolbarHeight;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

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
                              label: AppLocalizations.of(context)!.btmlabelone),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.calendar_today),
                              label: AppLocalizations.of(context)!.btmlabeltwo)
                        ],
                        currentIndex: 0,
                        onTap: (index) {
                          if (index == 1) {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        CalendarScreen(),
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .homeTitlestart,
                                          style: kTitleDecoration,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .homeTitleend,
                                          style: kTitleDecoration,
                                        )
                                      ],
                                    ),
                                    GestureDetector(
                                      child: Icon(Icons.settings),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SettingsScreen()),
                                        );
                                      },
                                    ),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  DateFormat.MMMM(
                                          Localizations.localeOf(context)
                                              .toString())
                                      .format(DateTime.now()),
                                  style: kMonthText,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CalendarButton(
                                        weekday:
                                            AppLocalizations.of(context)!.mon,
                                        date: selectDate(1),
                                        color: date1.weekday == 1
                                            ? Colors.blue
                                            : Colors.grey,
                                        funct: ()  {
                                            changeDate(1);
                                           
                                          
                                        }),
                                    CalendarButton(
                                      weekday:
                                          AppLocalizations.of(context)!.tue,
                                      date: selectDate(2),
                                      color: date1.weekday == 2
                                          ? Colors.blue
                                          : Colors.grey,
                                      funct: () {
                                        changeDate(2);
                                      },
                                    ),
                                    CalendarButton(
                                      weekday:
                                          AppLocalizations.of(context)!.wed,
                                      date: selectDate(3),
                                      color: date1.weekday == 3
                                          ? Colors.blue
                                          : Colors.grey,
                                      funct: () {
                                        changeDate(3);
                                      },
                                    ),
                                    CalendarButton(
                                      weekday:
                                          AppLocalizations.of(context)!.thu,
                                      date: selectDate(4),
                                      color: date1.weekday == 4
                                          ? Colors.blue
                                          : Colors.grey,
                                      funct: () {
                                        changeDate(4);
                                      },
                                    ),
                                    CalendarButton(
                                      weekday:
                                          AppLocalizations.of(context)!.fri,
                                      date: selectDate(5),
                                      color: date1.weekday == 5
                                          ? Colors.blue
                                          : Colors.grey,
                                      funct: () {
                                        changeDate(5);
                                      },
                                    ),
                                    CalendarButton(
                                      weekday:
                                          AppLocalizations.of(context)!.sat,
                                      date: selectDate(6),
                                      color: date1.weekday == 6
                                          ? Colors.blue
                                          : Colors.grey,
                                      funct: () {
                                        changeDate(6);
                                      },
                                    ),
                                    CalendarButton(
                                      weekday:
                                          AppLocalizations.of(context)!.sun,
                                      date: selectDate(7),
                                      color: date1.weekday == 7
                                          ? Colors.blue
                                          : Colors.grey,
                                      funct: () {
                                        changeDate(7);
                                      },
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
                          child: snapshot.hasData == false ? Container(
                          ) :
                          ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder:
                                (BuildContext context, int index) {
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
                                          .indexOf(formattedDate1)]==true ? slideRight() : slideLeft(),
                                key: Key(""),
                                child: MedicineCard(
                                  image: snapshot.data?.docs[index]['image'],
                                  name: snapshot.data?.docs[index]['name'],
                                  time: snapshot.data?.docs[index]['time'],
                                  doc: snapshot.data?.docs[index].reference.id,
                                  done: snapshot.data?.docs[index]['completed'][
                                      1],
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
                            label: AppLocalizations.of(context)!.btmlabelone),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.calendar_today),
                            label: AppLocalizations.of(context)!.btmlabeltwo)
                      ],
                      currentIndex: 0,
                      onTap: (index) {
                        if (index == 1) {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  CalendarScreen(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .homeTitlestart,
                                        style: kTitleDecoration,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .homeTitleend,
                                        style: kTitleDecoration,
                                      )
                                    ],
                                  ),
                                  GestureDetector(
                                    child: Icon(Icons.settings),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SettingsScreen()),
                                      );
                                    },
                                  ),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                DateFormat.MMMM(Localizations.localeOf(context)
                                        .toString())
                                    .format(DateTime.now()),
                                style: kMonthText,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CalendarButton(
                                        weekday:
                                            AppLocalizations.of(context)!.mon,
                                        date: selectDate(1),
                                        color: date1.weekday == 1
                                            ? Colors.blue
                                            : Colors.grey,
                                        funct: ()  {
                                            changeDate(1);
                                           
                                          
                                        }),
                                    CalendarButton(
                                      weekday:
                                          AppLocalizations.of(context)!.tue,
                                      date: selectDate(2),
                                      color: date1.weekday == 2
                                          ? Colors.blue
                                          : Colors.grey,
                                      funct: () {
                                        changeDate(2);
                                      },
                                    ),
                                    CalendarButton(
                                      weekday:
                                          AppLocalizations.of(context)!.wed,
                                      date: selectDate(3),
                                      color: date1.weekday == 3
                                          ? Colors.blue
                                          : Colors.grey,
                                      funct: () {
                                        changeDate(3);
                                      },
                                    ),
                                    CalendarButton(
                                      weekday:
                                          AppLocalizations.of(context)!.thu,
                                      date: selectDate(4),
                                      color: date1.weekday == 4
                                          ? Colors.blue
                                          : Colors.grey,
                                      funct: () {
                                        changeDate(4);
                                      },
                                    ),
                                    CalendarButton(
                                      weekday:
                                          AppLocalizations.of(context)!.fri,
                                      date: selectDate(5),
                                      color: date1.weekday == 5
                                          ? Colors.blue
                                          : Colors.grey,
                                      funct: () {
                                        changeDate(5);
                                      },
                                    ),
                                    CalendarButton(
                                      weekday:
                                          AppLocalizations.of(context)!.sat,
                                      date: selectDate(6),
                                      color: date1.weekday == 6
                                          ? Colors.blue
                                          : Colors.grey,
                                      funct: () {
                                        changeDate(6);
                                      },
                                    ),
                                    CalendarButton(
                                      weekday:
                                          AppLocalizations.of(context)!.sun,
                                      date: selectDate(7),
                                      color: date1.weekday == 7
                                          ? Colors.blue
                                          : Colors.grey,
                                      funct: () {
                                        changeDate(7);
                                      },
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
                          color: Colors.transparent, child: Container()),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
