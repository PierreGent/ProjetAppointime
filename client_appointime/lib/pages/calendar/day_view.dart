import 'package:client_appointime/pages/Appointment/appointment.dart';
import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/prestation.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/validation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import 'package:calendar_views/day_view.dart';

import 'utils/all.dart';

@immutable
class Event {
  Event({
    @required this.startMinuteOfDay,
    @required this.appointment,
    @required this.title,
    @required this.color,
  });

  final int startMinuteOfDay;
  final Appointment appointment;
  Color color;

  final String title;
}

class DayView extends StatefulWidget {
  DayView(this.business, this.day, this.presta, this.user, this.myBusiness);

  final Business business;
  final Prestation presta;
  final User user;
  final bool myBusiness;
  DateTime day;
  @override
  State createState() => new _DayViewState();
}

class _DayViewState extends State<DayView> {
  @override
  int openingDayTime;
  final format = new NumberFormat("00");
  double calendarSize = 2.5;
  bool isLoading;
  int closingDayTime;
  List<Event> eventsOfDay = [];
  List<Appointment> takenAppointment_user = [];
  List<Appointment> takenAppointment_business = [];
  void initState() {

    loadAppointment();
    Future.delayed(Duration(milliseconds: 800), () {

      loadEvent();

    });
    if (widget.presta != null) if (widget.presta.duration < 20)
      calendarSize = 3.5;
    super.initState();
  }

  Future<Prestation> loadPresta(String id) async {
    Prestation presta;
    await FirebaseDatabase.instance
        .reference()
        .child('prestation')
        .child(id)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) presta = Prestation.fromMap(id, values);
    });
    return presta;
  }

  Future<void> loadAppointment() async {
    setState(() {
      isLoading = true;
      takenAppointment_user = [];
      takenAppointment_business = [];
    });
    print(widget.business.id);
    Prestation presta;
    FirebaseDatabase.instance
        .reference()
        .child('appointment')
        .orderByChild('businessId')
        .equalTo(widget.business.id)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values == null) return;
      values.forEach((k, v) async {
        setState(() {
          isLoading = true;
        });
        print(v["dayAppointment"]+"  "+widget.day.toString());
        presta = null;
        String day= widget.day.toString().substring(0,10);
        if (v["dayAppointment"].toString().contains(day)) {
          getUser(v["user"]).then((DataSnapshot result) {
            Map<dynamic, dynamic> valuesUser = result.value;
            Map<String, dynamic> mailPass = new Map<String, dynamic>();
            mailPass['email'] = "";
            mailPass['password'] = "";
            loadPresta(v['prestation']).then((prestation) {

              setState(() {
                takenAppointment_business.add(Appointment.fromMap(k, v,
                    User.fromMap(mailPass, valuesUser, v["user"]), prestation));

                print("ajouté: " + takenAppointment_business.toString());
              });
              setState(() {
                isLoading = false;
              });
            });
          });
        }
      });
    });

    FirebaseDatabase.instance
        .reference()
        .child('appointment')
        .orderByChild("user")
        .equalTo(widget.user.id)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values == null) return;
      values.forEach((k, v) async {
        setState(() {
          isLoading = true;
        });
        presta = null;
        print(v["dayAppointment"]+"  "+widget.day.toString());
        String day= widget.day.toString().substring(0,10);
        if (v["dayAppointment"].toString().contains(day)) {
          loadPresta(v['prestation']).then((prestation){

              setState(() {

                takenAppointment_user
                    .add(Appointment.fromMap(k, v, widget.user, prestation));
                isLoading = false;
              });

          });
        }
      });
    });
  }

  void loadEvent() async {
    Color couleurConf;
    String title;
    setState(() {
      eventsOfDay = [];
      isLoading = true;

      for (Appointment appoint in takenAppointment_business) {
        print(appoint);
        title = "Cette plage horaire n'est pas disponible";
        if(widget.myBusiness)
          title= appoint.prestation.namePresta+" Pour "+appoint.user.firstName[0]+"."+appoint.user.lastName;
        couleurConf = Colors.red.withOpacity(0.5);
        if (!appoint.confirmed &&
            appoint.prestation.business == widget.business.id) {
          couleurConf = Colors.orange.withOpacity(0.5);
          title = title + " En cours de traitement";
        }
        print("\n\n\n" + appoint.user.id + widget.user.id);
        if (appoint.user.id != widget.user.id)
          setState(() {
            eventsOfDay.add(new Event(
                startMinuteOfDay: appoint.startTime,
                appointment: appoint,
                title: title,
                color: couleurConf));
          });

        print("\n\n" + takenAppointment_business.toString());
      }
      for (Appointment appoint in takenAppointment_user) {
        print(appoint);
        couleurConf = Colors.blue.withOpacity(0.5);
        title = "Vous n'êtes pas disponible (rendez vous pour " +
            appoint.prestation.namePresta +
            ")";
        if (!appoint.confirmed) {
          couleurConf = Colors.amber.withOpacity(0.5);
          title = title + " En cours de traitement";
        }

        setState(() {
          eventsOfDay.add(new Event(
              startMinuteOfDay: appoint.startTime,
              appointment: appoint,
              title: title,
              color: couleurConf));
        });
      }
      int midi;
      int katorzeur;
      if (widget.business.businessShedule != null)
        widget.business.businessShedule.forEach((k, v) {
          if ((v["halfDayId"] / 2) + 0.5 == widget.day.weekday) {
            midi = v["closingTime"];
          }
          if (v["halfDayId"] / 2 == widget.day.weekday)
            katorzeur = v["openingTime"];
          if (midi != null && katorzeur != null) {
            if (katorzeur - midi > 20)
              eventsOfDay.add(new Event(
                  startMinuteOfDay: midi,
                  appointment: Appointment(
                      confirmed: null,
                      id: null,
                      user: null,
                      day: null,
                      prestation: Prestation(
                          autoConf: null,
                          id: null,
                          business: null,
                          namePresta: null,
                          description: null,
                          duration: katorzeur - midi,
                          price: null),
                      startTime: null),
                  title: "FERME",
                  color: Colors.black12.withOpacity(0.5)));
            midi = null;
            katorzeur = null;
          }
          bool isGood=true;
          int closingTime = v["closingTime"];
          int openingTime = v["openingTime"];
          if ((v["halfDayId"] / 2) == widget.day.weekday ||
              (v["halfDayId"] / 2) + 0.5 == widget.day.weekday) {
            if (openingDayTime == null) openingDayTime = openingTime;
            if (openingTime < openingDayTime) openingDayTime = openingTime;

            if (closingDayTime == null) closingDayTime = closingTime;
            if (closingTime > closingDayTime) closingDayTime = closingTime;
            if (widget.presta != null)
              for (int i = openingTime;
                  i < closingTime;
                  i += widget.presta.duration) {
                isGood=true;
                if (i + widget.presta.duration < closingTime) {
                  for (Appointment appoint in takenAppointment_business)
                    if (i==appoint.startTime ||(i <= appoint.startTime &&
                            i + widget.presta.duration > appoint.startTime) ||
                        (i < appoint.startTime + appoint.prestation.duration &&
                            i >= appoint.startTime)) {
                      isGood=false;
                      //i = appoint.prestation.duration + appoint.startTime;
                    }
                  for (Appointment appoint in takenAppointment_user)
                    if (i==appoint.startTime ||(i <= appoint.startTime &&
                            i + widget.presta.duration > appoint.startTime) ||
                        (i < appoint.startTime + appoint.prestation.duration &&
                            i >= appoint.startTime)) {
                      isGood=false;
                    //  i = appoint.prestation.duration + appoint.startTime;
                    }
                  if (i + widget.presta.duration < closingTime && isGood)
                    eventsOfDay.add(new Event(
                        startMinuteOfDay: i,
                        appointment: Appointment(
                            confirmed: null,
                            id: null,
                            user: null,
                            day: null,
                            prestation: widget.presta,
                            startTime: null),
                        title: widget.day.weekday.toString() +
                            "plage horaire disponible pour: " +
                            widget.presta.namePresta +
                            " de " +
                            (i ~/ 60).toString() +
                            "h " +
                            '${format.format(i % 60)}' +
                            "min à " +
                            ((i + widget.presta.duration) ~/ 60).toString() +
                            "h " +
                            '${format.format((i + widget.presta.duration) % 60)}' +
                            "min",
                        color: Colors.green.withOpacity(0.5)));
                }
              }
          }
        });
      if(openingDayTime!=null){
      print(openingDayTime.toString() + closingDayTime.toString());
      eventsOfDay.add(new Event(
          startMinuteOfDay: openingDayTime - 60,
          appointment: Appointment(
              id: null,
              user: null,
              day: null,
              confirmed: null,
              prestation: Prestation(
                  id: null,
                  business: null,
                  autoConf: null,
                  namePresta: null,
                  description: null,
                  duration: 60,
                  price: null),
              startTime: null),
          title: "FERME",
          color: Colors.black12.withOpacity(0.5)));
      eventsOfDay.add(new Event(
          startMinuteOfDay: closingDayTime,
          appointment: Appointment(
              id: null,
              user: null,
              day: null,
              confirmed: null,
              prestation: Prestation(
                  id: null,
                  business: null,
                  autoConf: null,
                  namePresta: null,
                  description: null,
                  duration: 60,
                  price: null),
              startTime: null),
          title: "FERME",
          color: Colors.black12.withOpacity(0.5)));
      }
    });

    setState(() {
      isLoading = false;
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
                duration: event.appointment.prestation.duration,
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

  void _showDialog(Event event) {
    if (event.color == Colors.black12.withOpacity(0.5)) return;
    int start = event.startMinuteOfDay;
    // flutter defined function
    ontap() {
      if (event.color == Colors.green.withOpacity(0.5)) {
        FirebaseDatabase.instance.reference().child('appointment').push().set({
          'user': widget.user.id,
          'prestation': widget.presta.id,
          'startAppointment': event.startMinuteOfDay,
          'dayAppointment': widget.day.toString(),
          'businessId': widget.presta.business,
          'confirmed': event.appointment.prestation.autoConf
        });
      } else {
        FirebaseDatabase.instance
            .reference()
            .child('appointment')
            .child(event.appointment.id)
            .set({
          'user': event.appointment.user.id,
          'prestation': event.appointment.prestation.id,
          'startAppointment': event.startMinuteOfDay,
          'dayAppointment': event.appointment.day.toString(),
          'businessId': event.appointment.prestation.business,
          'confirmed': true
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        var action = [
          new FlatButton(
            child: new Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ];
        var title = Text("Attention");
        Widget content = Text("Cette plage horaire n'est pas disponible");
        if (event.color == Colors.blue.withOpacity(0.5)) {
          title = Text("Mon rendez-vous");
          content = Text(event.title);
        }
        if (event.color == Colors.green.withOpacity(0.5) ||
            (widget.presta == null &&
                !event.appointment.confirmed &&
                event.color == Colors.orange.withOpacity(0.5))) {
          action = [
            new FlatButton(
              child: new Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Confirmer"),
              onPressed: () {
                setState(() {
                  ontap();
                });
                Navigator.of(context).pop();

                if (widget.myBusiness) {
                  setState(() {
                    takenAppointment_business
                        .singleWhere((e) => e.id == event.appointment.id,
                            orElse: () => null)
                        .confirmed = true;

                    loadEvent();
                  });
                } else {
                  setState(() {
                    loadAppointment();
                    Future.delayed(
                        Duration(milliseconds: 800), () {
                      setState(() {
                        isLoading = true;
                      });
                      loadEvent();
                      setState(() {
                    isLoading = false;
                    });});
                  });
                }

                _showDialogCheck();
              },
            )
          ];
          if (!widget.myBusiness)
            content = Text(
                "Etes vous sur de vouloir prendre ce rendez vous pour " +
                    widget.presta.namePresta +
                    " le " +
                    widget.day.toString() +
                    " de " +
                    (start ~/ 60).toString() +
                    "h " +
                    '${format.format(start % 60)}' +
                    "min à " +
                    ((start + widget.presta.duration) ~/ 60).toString() +
                    "h " +
                    '${format.format((start + widget.presta.duration) % 60)}' +
                    "min?");
        }
        if (widget.myBusiness) {
          content = SizedBox(
            height: 100,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Pour :" + event.appointment.prestation.namePresta),
                  Text("Utilisateur: " +
                      event.appointment.user.firstName.substring(0, 1) +
                      ". " +
                      event.appointment.user.lastName),
                  Row(
                    children: <Widget>[
                      Icon(Icons.warning,
                          color: Colors.redAccent.withOpacity(0.5)),
                      Text("A CONFIRMER"),
                    ],
                  )
                ]),
          );
          if (event.appointment.confirmed) {
            title = Text("Rendez vous de " +
                (start ~/ 60).toString() +
                "h" +
                '${format.format(start % 60)}' +
                "");
            content = SizedBox(
              height: 100,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Pour :" + event.appointment.prestation.namePresta),
                    Text("Utilisateur: " +
                        event.appointment.user.firstName.substring(0, 1) +
                        ". " +
                        event.appointment.user.lastName),
                  ]),
            );
          }
        }
        return AlertDialog(
          title: title,
          content: content,
          actions: action,
        );
      },
    );
  }

  void _showDialogCheck() {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Terminé"),
          content: new Text("Votre rendez vous a été enegistré"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Widget content() {
    if (widget.business.businessShedule == null)
      return new Center(
        child: Text("Cette entreprise n'a pas spécifié d'horaires",
            style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
      );
    if (openingDayTime == null || closingDayTime == null)
      return new Center(
        child: Text("Aucun horaire spécifié pour ce jour",
            style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
      );
    return new DayViewEssentials(
      properties: new DayViewProperties(
        maximumMinuteOfDay: closingDayTime + 60,
        minimumMinuteOfDay: openingDayTime - 60,
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
                heightPerMinute: calendarSize,
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
                    generatedDaySeparatorBuilder: _generatedDaySeparatorBuilder,
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
    if (isLoading)
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Chargement du calendrier"),
        ),
        body: new Center(
          child: CircularProgressIndicator(),
        ),
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
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: () => setState(() {
                      widget.day = widget.day.add(Duration(days: -1));
                      loadAppointment();
                      Future.delayed(Duration(milliseconds: 800), () {
                        loadEvent();
                        isLoading = false;
                      });
                      if (widget.presta != null) if (widget.presta.duration <
                          20) calendarSize = 3.5;
                    })),
            Column(
              children: <Widget>[
                new Text(
                  "${weekdayToString(day.weekday)} " + "${day.day}",
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text("${yearAndMonthToString(day)}"),
              ],
            ),
            IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () => setState(() {
                      widget.day = widget.day.add(Duration(days: 1));
                      loadAppointment();
                      Future.delayed(Duration(milliseconds: 800), () {
                        loadEvent();
                        isLoading = false;
                      });
                      if (widget.presta != null) if (widget.presta.duration <
                          20) calendarSize = 3.5;
                    })),
          ],
        ));
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
        onTap: () => _showDialog(event),
        child: new Container(
          margin: new EdgeInsets.only(left: 1.0, right: 1.0, bottom: 1.0),
          padding: new EdgeInsets.all(3.0),
          color: event.color,
          child: new Center(
              child: Text(
            "${event.title}",
            textAlign: TextAlign.center,
          )),
        ),
      ),
    );
  }
}
