import 'package:client_appointime/pages/Appointment/appointment.dart';
import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/prestation.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:client_appointime/validation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyAppointmentBody extends StatefulWidget {
  @override
  MyAppointmentBody(this.user,this.old,this.toConfirm);

  final User user;
  final bool old;
  final bool toConfirm;

  State<StatefulWidget> createState() => new MyAppointmentBodyState();
}

class MyAppointmentBodyState extends State<MyAppointmentBody> {
  List<Appointment> appointment = [];
  Prestation presta;
  bool _isLoading;
  final format = new NumberFormat("00");

  void initState() {
    loadAppointment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading)
      return new Scaffold(
        body: CircularProgressIndicator(),
      );
    return new Scaffold(
      body: ListView.builder(
        itemCount: appointment.length,
        itemBuilder: buildAppointmentListTile,
      ),
    );
  }

  Widget buildAppointmentListTile(BuildContext context, int index) {
    Appointment appoint = appointment[index];
    Prestation prestation;
    Future.delayed(Duration(milliseconds: 200), () async {
      prestation = await loadPresta(appoint.prestation.toString());
    });

    int heureDebut = appoint.startTime;
    int heureFin = appoint.startTime + presta.duration;

    DateTime date = appoint.day;

    return Card(
      child: ListTile(
        title: new Text(appoint.prestation.namePresta,textAlign: TextAlign.right,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20,color: Colors.blueAccent),),
        subtitle: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  Icon(Icons.calendar_today,size: 20),
                  Text(" " + format.format(date.day) +"/"+ format.format(date.month) +"/"+ date.year.toString()),

                ],
              ),
              new Row(
                children: <Widget>[
                  Icon(Icons.timer,size: 20,),
                  Text(" " + format.format(heureDebut~/60) +"h"+ format.format(heureDebut%60) +" à " + format.format(heureFin~/60) +"h"+ format.format(heureFin%60)),

                ],
              ),
            ]) ,
        trailing: tempsRestant(appoint),
      ),
    );
  }
DateTime getTime(Appointment appoint){
  return DateTime(appoint.day.year,appoint.day.month,appoint.day.day,(appoint.startTime~/60),(appoint.startTime%60),0,0,0);

}
  Widget tempsRestant(Appointment appoint){
    DateTime day=getTime(appoint);
    if(day.difference(DateTime.now()).inMinutes<0)
      return new Column(
        children: <Widget>[
          Icon(Icons.directions_run,size: 20,color: Colors.redAccent,),
          new Text("il y a " + day.difference(DateTime.now()).inMinutes.abs().toString()+" min",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
        ],
      );

    if(day.difference(DateTime.now()).inMinutes<120)
      return new Column(
        children: <Widget>[
          Icon(Icons.warning,size: 20,color: Colors.redAccent,),
          new Text("dans " + day.difference(DateTime.now()).inMinutes.toString()+" min",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
        ],
      );

    if(day.difference(DateTime.now()).inDays==0&& day.difference(DateTime.now()).inMinutes>0)
      return new Column(
        children: <Widget>[
          Icon(Icons.warning,size: 20,color: Colors.redAccent,),
          new Text("dans " +
              day.
              difference(DateTime.now()).inHours.toString()+":"+
              (day.
              difference(DateTime.now()).inMinutes%60).toString(),
            style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
        ],
      );
    if(day.difference(DateTime.now()).inDays<3)
      return new Column(
        children: <Widget>[
          Icon(Icons.warning,size: 20,color: Colors.redAccent,),
          new Text("dans " +
              day.difference(DateTime.now()).inDays.toString()+
              " jours",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
        ],
      );

    return new Column(
      children: <Widget>[
        new Text("dans " + day.difference(DateTime.now()).inDays.toString()+" jours"),
      ],
    );

  }
  Future<void> loadAppointment() async {
    setState(() {
      _isLoading=true;
    });
    appointment = [];
    Appointment appoint;
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
        presta = null;
        getUser(v["user"]).then((DataSnapshot result) {
          Map<dynamic, dynamic> valuesUser = result.value;
          Map<String, dynamic> mailPass = new Map<String, dynamic>();
          mailPass['email'] = "";
          mailPass['password'] = "";
if(this.mounted)
          setState(() {
            Future.delayed(Duration(milliseconds: 200), () async {
              presta = await loadPresta(v['prestation']);

                appoint=Appointment.fromMap(
                    k, v, User.fromMap(mailPass, valuesUser, v["user"]),
                    presta);
               appoint.day=getTime(appoint);
                if(appoint.confirmed && appoint.day.difference(DateTime.now()).inMinutes>(-20)&&!widget.old&&!widget.toConfirm) {
                  appointment.add(appoint);
                  appointment.sort((a, b) => a.day.compareTo(b.day));
                }
                if(appoint.day.difference(DateTime.now()).inMinutes<(0)&&widget.old) {
                  appointment.add(appoint);
                  appointment.sort((a, b) => b.day.compareTo(a.day));
                }
                if(appoint.day.difference(DateTime.now()).inMinutes>(-20)&&widget.toConfirm && !appoint.confirmed) {
                  appointment.add(appoint);
                  appointment.sort((a, b) => a.day.compareTo(b.day));
                }
                if(this.mounted)
              setState(() {
                _isLoading=false;
              });
            });
          });
        });
      });
    });

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
}
