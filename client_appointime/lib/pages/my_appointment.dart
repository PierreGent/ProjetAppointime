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
        title: new Text(appoint.prestation.namePresta),
        subtitle: new Text("le " + format.format(date.day) +"/"+ format.format(date.month) +"/"+ date.year.toString()),
        trailing: Text("de " + format.format(heureDebut~/60) +"h"+ format.format(heureDebut%60) +
            " à " + format.format(heureFin~/60) +"h"+ format.format(heureFin%60)),
      ),
    );
  }

  Future<void> loadAppointment() async {
    print(widget.user.id);
    appointment = [];
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
                appointment.add(Appointment.fromMap(
                    k, v, User.fromMap(mailPass, valuesUser, v["user"]),
                    presta));
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
