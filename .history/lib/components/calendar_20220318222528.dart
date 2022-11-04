import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, WeekdayFormat;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';



class CalendarCar extends StatefulWidget {
  const CalendarCar({ Key? key }) : super(key: key);

  @override
  State<CalendarCar> createState() => _CalendarCarState();
}

class _CalendarCarState extends State<CalendarCar> {
  @override
  Widget build(BuildContext context) {
    DateTime i=DateTime(2019, 2, 3);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          setState(() {
            i=DateTime(2019, 4, 3);
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
    );
  }
  EventList<Event> _getCarouselMarkedDates() {
    return EventList<Event>(
      events: {
        new DateTime(2022, 3, 3): [
          new Event(
            date: new DateTime(2019, 4, 3),
            title: 'Event 1',
          ),
        ],
        new DateTime(2022, 3, 5): [
          new Event(
            date: new DateTime(2019, 4, 5),
            title: 'Event 1',
          ),
        ],
        new DateTime(2022, 3, 22): [
          new Event(
            date: new DateTime(2019, 4, 22),
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