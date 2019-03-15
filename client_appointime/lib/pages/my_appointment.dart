import 'package:client_appointime/pages/Appointment/appointment.dart';
import 'package:client_appointime/pages/business/prestation.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:client_appointime/validation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyAppointment extends StatefulWidget {
  @override
  MyAppointment(this.user);

  final User user;

  State<StatefulWidget> createState() => new MyAppointmentState();
}

class MyAppointmentState extends State<MyAppointment> {
  List<Appointment> appointment = [];
  Prestation presta;
  final format = new NumberFormat("00");

  void initState() {
    super.initState();
    loadAppointment();
    print(appointment.length);
  }

  @override
  Widget build(BuildContext context) {
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
    print("pulllller");
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

  Widget tempsRestant(Appointment appoint){
    if(appoint.day.difference(DateTime.now()).inMinutes<0)
      return new Column(
        children: <Widget>[
          Icon(Icons.directions_run,size: 20,color: Colors.redAccent,),
          new Text("il y a " + appoint.day.difference(DateTime.now()).inMinutes.abs().toString()+" min",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
        ],
      );

    if(appoint.day.difference(DateTime.now()).inMinutes<120)
      return new Column(
        children: <Widget>[
          Icon(Icons.warning,size: 20,color: Colors.redAccent,),
          new Text("dans " + appoint.day.difference(DateTime.now()).inMinutes.toString()+" min",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
        ],
      );

    if(appoint.day.difference(DateTime.now()).inDays==0)
      return new Column(
        children: <Widget>[
          Icon(Icons.warning,size: 20,color: Colors.redAccent,),
          new Text("dans " + appoint.day.difference(DateTime.now()).inHours.toString()+":"+
              '${format.format(appoint.day.difference(DateTime.now()).inMinutes)}',style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
        ],
      );
    if(appoint.day.difference(DateTime.now()).inDays<3)
      return new Column(
      children: <Widget>[
          Icon(Icons.warning,size: 20,color: Colors.redAccent,),
        new Text("dans " + appoint.day.difference(DateTime.now()).inDays.toString()+" jours",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
      ],
    );

    return new Column(
        children: <Widget>[
    new Text("dans " + appoint.day.difference(DateTime.now()).inDays.toString()+" jours"),
    ],
    );

  }

  Future<void> loadAppointment() async {
    print(widget.user.id);
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
        print("OKKKKKK");
        presta = null;
        getUser(v["user"]).then((DataSnapshot result) {
          Map<dynamic, dynamic> valuesUser = result.value;
          Map<String, dynamic> mailPass = new Map<String, dynamic>();
          mailPass['email'] = "";
          mailPass['password'] = "";

        setState(() {
            Future.delayed(Duration(milliseconds: 200), () async {
              presta = await loadPresta(v['prestation']);
              setState(() {
                appoint=Appointment.fromMap(
                    k, v, User.fromMap(mailPass, valuesUser, v["user"]),
                    presta);
                if(appoint.day.difference(DateTime.now()).inMinutes>(-20))
                  appointment.add(appoint);
                appointment.sort((a, b) => a.day.compareTo(b.day));
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
