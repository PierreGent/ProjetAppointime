import 'package:client_appointime/pages/Appointment/appointment.dart';
import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/prestation.dart';
import 'package:client_appointime/pages/my_appointment_body.dart';
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

class MyAppointmentState extends State<MyAppointment>
    with TickerProviderStateMixin {
  TabController _controller;
  List<Tab> _tabs;
  List<Widget> _pages;
  void initState(){
    _tabs = [
      new Tab(child: Icon(Icons.description, color: Colors.black54)),
      new Tab(child: Icon(Icons.work, color: Colors.black54)),

      new Tab(icon:  Icon(Icons.calendar_today, color: Colors.black54)),
    ];
    _pages = [
      new MyAppointmentBody(widget.user,false,false),
      new MyAppointmentBody(widget.user,false,true),

      new MyAppointmentBody(widget.user,true,false),
    ];
     _controller = new TabController(
      length: _tabs.length,
      vsync: this,
    );

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TabBar(
            controller: _controller,
            tabs: _tabs,
            indicatorColor: Colors.black54,
          ),
          new SizedBox.fromSize(
            size: const Size.fromHeight(300.0),
            child: new TabBarView(
              controller: _controller,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}
