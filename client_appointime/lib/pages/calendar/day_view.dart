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
  int openingDayTime;
  bool isLoading;
  int closingDayTime;
  List<Event> eventsOfDay=[];
  void initState() {
    loadEvent();
    super.initState();
  }
  void loadEvent(){
    setState(() {
      isLoading=true;
    });
if(widget.business.businessShedule!=null)
  widget.business.businessShedule.forEach((k,v){
    setState(() {

    int closingTime=v["closingTime"];
    int openingTime=v["openingTime"];
    if((v["halfDayId"]/2)==widget.day.weekday || (v["halfDayId"]/2)+0.5==widget.day.weekday) {
      if (openingDayTime == null)
        openingDayTime = openingTime;
      if (openingTime < openingDayTime)
        openingDayTime = openingTime;

      if (closingDayTime == null)
        closingDayTime = closingTime;
      if (closingTime > closingDayTime)
        closingDayTime = closingTime;
      for (int i = openingTime; i < closingTime; i += widget.presta.duration)
        if (i + widget.presta.duration < closingTime)
          eventsOfDay.add(new Event(startMinuteOfDay: i,
              duration: widget.presta.duration,
              title: widget.day.weekday.toString() +
                  "plage horaire disponible pour: " + widget.presta.namePresta,
              isFree: true));
    }
    });
  });
    setState(() {
      isLoading=false;
    });
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
Widget content(){

  if(widget.business.businessShedule==null)
    return new Center(
      child: Text("Cette entreprise n'a pas spécifié d'horaires",style: TextStyle(fontSize: 30),textAlign: TextAlign.center),
    );
  if(!isLoading && (openingDayTime==null || closingDayTime==null))
    return new Center(
      child: Text("Aucun horaire spécifié pour ce jour",style: TextStyle(fontSize: 30),textAlign: TextAlign.center),
    );
  new DayViewEssentials(
    properties: new DayViewProperties(
      maximumMinuteOfDay: closingDayTime+60,
      minimumMinuteOfDay: openingDayTime-60,
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
  );
}
  @override
  Widget build(BuildContext context) {
    if(isLoading)
      return new Center(
        child: CircularProgressIndicator(),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Prendre un rendez vous"),
      ),
      body: content(),
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
