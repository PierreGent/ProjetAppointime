import 'package:flutter/material.dart';
import 'globalVar.dart' as globalVar;
import 'login.dart';
import 'register.dart';


void main() => runApp(App());

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    final title = 'Appointime';
    return MaterialApp(
      title: title,
      home: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: globalVar.couleurPrimaire,
        body: PageView(
          controller: globalVar.pageController,
          children: <Widget>[
            ConnectPage(),
            InscPage(),
          ],
        ));
  }
}






