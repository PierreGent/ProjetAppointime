import 'package:client_appointime/pages/business/business.dart';
import 'package:flutter/material.dart';

class ConditionsShowcase extends StatelessWidget {
  ConditionsShowcase(this.friend);
  final Business friend;
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return new Row(
      children: <Widget>[
    new Icon(
    Icons.timer,
      color: Colors.white,
      size: 16.0,
    ),
     new Text(
        "il faut annuler "+friend.cancelAppointment.toString()+" jours avant",
        style: textTheme.title.copyWith(color: Colors.white),
      ),
  ],);
  }
}