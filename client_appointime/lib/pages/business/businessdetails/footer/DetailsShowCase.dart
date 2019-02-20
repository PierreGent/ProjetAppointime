
import 'package:client_appointime/pages/business/business.dart';
import 'package:flutter/material.dart';

class DetailsShowcase extends StatelessWidget {
  DetailsShowcase(this.business);

  final Business business;
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Text("Description: "+business.description),
        Text("Annulation de rendez vous: minimum"+business.cancelAppointment.toString()+" à l'avance."),
      ],
    );
  }
}
