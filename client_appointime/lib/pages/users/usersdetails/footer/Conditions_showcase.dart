import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:flutter/material.dart';

class ConditionsShowcase extends StatelessWidget {
  ConditionsShowcase(this.user);
  final User user;
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
        "Vous avez "+user.credit.toString()+" points de credibilité",
        style: textTheme.title.copyWith(color: Colors.white),
      ),
  ],);
  }
}