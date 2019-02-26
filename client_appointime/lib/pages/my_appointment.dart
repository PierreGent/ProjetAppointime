import 'package:client_appointime/services/authentication.dart';
import 'package:flutter/material.dart';

class MyAppointment extends StatefulWidget {
  @override
  MyAppointment({this.auth, this.userId, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  State<StatefulWidget> createState() => new MyAppointmentState();
}

class MyAppointmentState extends State<MyAppointment> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "Liste des rendez-vous",
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
