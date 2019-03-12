import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/prestation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:calendar_views/day_view.dart';

import 'utils/all.dart';

@immutable
class Event {
  Event({
    @required this.startMinuteOfDay,
    @required this.duration,
    @required this.title,
    @required this.isFree,

  });

  final int startMinuteOfDay;
  final int duration;
  final bool isFree;

  final String title;
}




class DayView extends StatefulWidget {
  DayView(this.business, this.day,this.presta);

  final Business business;
  final Prestation presta;
  final DateTime day;
  @override
  State createState() => new _DayViewState();
}

class _DayViewState extends State<DayView> {
  @override
  List<Event> eventsOfDay=[];
  void initState() {
    loadEvent();
    super.initState();
  }
  void loadEvent(){
    for(int i=480;i<1200;i+=widget.presta.duration)
      eventsOfDay.add(new Event(startMinuteOfDay: i, duration: widget.presta.duration, title: "plage horaire disponible pour: "+widget.presta.namePresta, isFree: true));
  }

  String _minuteOfDayToHourMinuteString(int minuteOfDay) {
    return "${(minuteOfDay ~/ 60).toString().padLeft(2, "0")}"
        ":"
        "${(minuteOfDay % 60).toString().padLeft(2, "0")}";
  }

  List<StartDurationItem> _getEventsOfDay(DateTime day) {
    List<Event> events;

    events = eventsOfDay;

    return events
        .map(
          (event) => new StartDurationItem(
                startMinuteOfDay: event.startMinuteOfDay,
                duration: event.duration,

                builder: (context, itemPosition, itemSize) => _eventBuilder(
                      context,
                      itemPosition,
                      itemSize,
                      event,
                    ),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Prendre un rendez vous"),
      ),
      body: new DayViewEssentials(
        properties: new DayViewProperties(
          maximumMinuteOfDay: 1200,
          minimumMinuteOfDay: 480,
          days: <DateTime>[
            widget.day,
          ],
        ),
        child: new Column(
          children: <Widget>[
            new Container(

              color: Colors.grey[200],
              child: new DayViewDaysHeader(

                headerItemBuilder: _headerItemBuilder,
              ),
            ),
            new Expanded(
              child: new SingleChildScrollView(
                child: new DayViewSchedule(

                  heightPerMinute: 1.5,
                  components: <ScheduleComponent>[
                    new TimeIndicationComponent.intervalGenerated(

                      timeIndicatorDuration: 30,
                      generatedTimeIndicatorBuilder:
                          _generatedTimeIndicatorBuilder,
                    ),
                    new SupportLineComponent.intervalGenerated(
                      interval: 60,
                      generatedSupportLineBuilder: _generatedSupportLineBuilder,
                    ),
                    new DaySeparationComponent(
                      generatedDaySeparatorBuilder:
                          _generatedDaySeparatorBuilder,
                    ),
                    new EventViewComponent(

                      getEventsOfDay: _getEventsOfDay,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerItemBuilder(BuildContext context, DateTime day) {
    return new Container(
      color: Colors.grey[300],
      padding: new EdgeInsets.symmetric(vertical: 4.0),
      child: new Column(
        children: <Widget>[
          new Text(
            "${weekdayToAbbreviatedString(day.weekday)}",
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
          new Text("${day.day}"),
        ],
      ),
    );
  }

  Positioned _generatedTimeIndicatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int minuteOfDay,
  ) {
    return new Positioned(

      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new Container(

        child: new Center(
          child: new Text(_minuteOfDayToHourMinuteString(minuteOfDay)),
        ),
      ),
    );
  }

  Positioned _generatedSupportLineBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    double itemWidth,
    int minuteOfDay,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemWidth,
      child: new Container(
        height: 0.7,
        color: Colors.grey[700],
      ),
    );
  }

  Positioned _generatedDaySeparatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int daySeparatorNumber,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new Center(
        child: new Container(
          width: 0.7,
          color: Colors.grey,
        ),
      ),
    );
  }

  Positioned _eventBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    Event event,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new GestureDetector(
        onTap: ()=>print("details"),
        child:new Container(
        margin: new EdgeInsets.only(left: 1.0, right: 1.0, bottom: 1.0),
        padding: new EdgeInsets.all(3.0),
        color: Colors.green[200],

        child: new Text("${event.title}"),
      ),),
    );
  }
}
