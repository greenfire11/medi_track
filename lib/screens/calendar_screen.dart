import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _selectedIndex = 0;
  DateTime i = DateTime.now();
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
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today), label: 'Calendar')
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage2()),
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
                    top: 10, left: 15, right: 15, bottom: 5),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: CalendarCarousel<Event>(
                    onDayPressed: (DateTime date, List<Event> events) {
                      setState(() {
                        i = date;
                      });
                      print(date);
                      //take an action with date and its events
                    },
                    thisMonthDayBorderColor: Colors.transparent,
                    selectedDayButtonColor: Color(0xFF30A9B2),
                    selectedDayBorderColor: Color(0xFF30A9B2),
                    selectedDayTextStyle: TextStyle(color: Colors.black),
                    weekendTextStyle: TextStyle(color: Colors.black),
                    daysTextStyle: TextStyle(color: Colors.black),
                    nextDaysTextStyle: TextStyle(color: Colors.grey),
                    prevDaysTextStyle: TextStyle(color: Colors.grey),
                    weekdayTextStyle: TextStyle(color: Colors.grey),
                    weekDayFormat: WeekdayFormat.short,
                    firstDayOfWeek: 0,
                    showHeader: true,
                    isScrollable: true,
                    weekFormat: false,
                    height: 350.0,
                    selectedDateTime: i,
                    daysHaveCircularBorder: true,
                    customGridViewPhysics: NeverScrollableScrollPhysics(),
                    markedDatesMap: _getCarouselMarkedDates(),
                    markedDateWidget: Container(
                      height: 3,
                      width: 3,
                      decoration: new BoxDecoration(
                        color: Color(0xFF30A9B2),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(335)),
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

  EventList<Event> _getCarouselMarkedDates() {
    return EventList<Event>(
      events: {
        new DateTime(2022, 3, 3): [
          new Event(
            date: new DateTime(2019, 3, 3),
            title: 'Event 1',
          ),
        ],
        new DateTime(2022, 3, 5): [
          new Event(
            date: new DateTime(2019, 3, 5),
            title: 'Event 1',
          ),
        ],
        new DateTime(2022, 3, 22): [
          new Event(
            date: new DateTime(2019, 3, 22),
            title: 'Event 1',
          ),
        ],
        new DateTime(2022, 3, 24): [
          new Event(
            date: new DateTime(2022, 3, 24),
            title: 'Event 1',
          ),
        ],
        new DateTime(2022, 3, 26): [
          new Event(
            date: new DateTime(2022, 3, 26),
            title: 'Event 1',
          ),
        ],
      },
    );
  }
}
