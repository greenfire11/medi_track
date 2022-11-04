import 'package:flutter/material.dart';


class MyHomePage3 extends StatefulWidget {
    const MyHomePage3({Key? key,required this.date2}) : super(key: key);
  final DateTime date2;
  @override
  State<MyHomePage3> createState() => _MyHomePage3State();
}

class _MyHomePage3State extends State<MyHomePage3> {
  @override
late DateTime date1;
    @override
  void initState() {
    date1=widget.date2;
  }

  late final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection("YN0Y8HQaIGVyzgZ1I9IGSw2E4PB2")
      .where('dates', arrayContainsAny: [
    DateFormat('dd.MM.yyyy').format(widget.date2)
  ]).snapshots(includeMetadataChanges: true);
  int _selectedIndex = 0;
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
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.hasData) {
              print(snapshot.data!.docs[0]['image']);
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
                                      funct: () {
                                          if (date1.weekday > 1) {
                                            setState(() {
                                              date1 = date1.subtract(Duration(
                                                  days: date1.weekday - 1));
                                            });
                                          } else if (date1.weekday < 1) {
                                            setState(() {
                                              date1 = date1.add(Duration(
                                                  days: 1 - date1.weekday));
                                            });
                                          }
                                      },
                                    ),
                                    CalendarButton(
                                      weekday:
                                          AppLocalizations.of(context)!.tue,
                                      date: selectDate(2),
                                      color: date1.weekday == 2
                                          ? Colors.blue
                                          : Colors.grey,
                                      funct: () {
                                        if (date1.weekday > 2) {
                                          setState(() {
                                            date1 = date1.subtract(Duration(
                                                days: date1.weekday - 2));
                                          });
                                        } else if (date1.weekday < 2) {
                                          setState(() {
                                            date1 = date1.add(Duration(
                                                days: 2 - date1.weekday));
                                          });
                                        }
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
                                        if (date1.weekday > 3) {
                                          setState(() {
                                            date1 = date1.subtract(Duration(
                                                days: date1.weekday - 3));
                                          });
                                        } else if (date1.weekday < 3) {
                                          setState(() {
                                            date1 = date1.add(Duration(
                                                days: 3 - date1.weekday));
                                          });
                                        }
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
                                        if (date1.weekday > 4) {
                                          setState(() {
                                            date1 = date1.subtract(Duration(
                                                days: date1.weekday - 4));
                                          });
                                        } else if (date1.weekday < 4) {
                                          setState(() {
                                            date1 = date1.add(Duration(
                                                days: 4 - date1.weekday));
                                          });
                                        }
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
                                        if (date1.weekday > 5) {
                                          setState(() {
                                            date1 = date1.subtract(Duration(
                                                days: date1.weekday - 5));
                                          });
                                        } else if (date1.weekday < 5) {
                                          setState(() {
                                            date1 = date1.add(Duration(
                                                days: 5 - date1.weekday));
                                          });
                                        }
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
                                        if (date1.weekday > 6) {
                                          setState(() {
                                            date1 = date1.subtract(Duration(
                                                days: date1.weekday - 6));
                                          });
                                        } else if (date1.weekday < 6) {
                                          setState(() {
                                            date1 = date1.add(Duration(
                                                days: 6 - date1.weekday));
                                          });
                                        }
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
                                        if (date1.weekday > 7) {
                                          setState(() {
                                            date1 = date1.subtract(Duration(
                                                days: date1.weekday - 7));
                                          });
                                        } else if (date1.weekday < 7) {
                                          setState(() {
                                            date1 = date1.add(Duration(
                                                days: 7 - date1.weekday));
                                          });
                                        }
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
                          child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(height: 30);
                            },
                            padding: EdgeInsets.fromLTRB(15, 25, 15, 45),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    /// edit item
                                    return false;
                                  } else if (direction ==
                                      DismissDirection.startToEnd) {
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
                                  image: snapshot.data!.docs[index]['image'],
                                  name: snapshot.data!.docs[index]['name'],
                                  time: snapshot.data!.docs[index]['time'],
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
                                    weekday: AppLocalizations.of(context)!.mon,
                                    date: "7",
                                    color: Colors.grey,
                                  ),
                                  CalendarButton(
                                    weekday: AppLocalizations.of(context)!.tue,
                                    date: "8",
                                    color: Colors.grey,
                                  ),
                                  CalendarButton(
                                    weekday: AppLocalizations.of(context)!.wed,
                                    date: "9",
                                    color: Colors.blue,
                                  ),
                                  CalendarButton(
                                    weekday: AppLocalizations.of(context)!.thu,
                                    date: "10",
                                    color: Colors.grey,
                                  ),
                                  CalendarButton(
                                    weekday: AppLocalizations.of(context)!.fri,
                                    date: "11",
                                    color: Colors.grey,
                                  ),
                                  CalendarButton(
                                    weekday: AppLocalizations.of(context)!.sat,
                                    date: "12",
                                    color: Colors.grey,
                                  ),
                                  CalendarButton(
                                    weekday: AppLocalizations.of(context)!.sun,
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