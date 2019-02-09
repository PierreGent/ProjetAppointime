import 'package:flutter/material.dart';

class PrestationsShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return new Center(
      child: new Text(
        'ETOUAIS JSUIS INFORMATICIEN!!! HE HO JE CONNAIS FLUTTER ET OH LES MEUFS',
        style: textTheme.title.copyWith(color: Colors.blueGrey),
      ),
    );
  }
}
