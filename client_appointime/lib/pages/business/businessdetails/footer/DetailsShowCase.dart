import 'package:client_appointime/pages/business/business.dart';
import 'package:flutter/material.dart';

class DetailsShowcase extends StatelessWidget {
  DetailsShowcase(this.business);

  final Business business;

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Description: ",
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        Text(business.description, style: TextStyle(fontSize: 18)),
        Text(
          "\nPolitique d'annulation: ",
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        Text(
            "Annulation de rendez vous: minimum " +
                business.cancelAppointment.toString() +
                " jours à l'avance.",
            style: TextStyle(fontSize: 18)),
      ],
    );
  }
}
