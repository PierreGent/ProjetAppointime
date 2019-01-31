import 'package:flutter/material.dart';
import 'package:client_appointime/pages/root_page.dart';
import 'package:client_appointime/services/authentication.dart';


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
    return new MaterialApp(
        title: 'Appointime',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth()));
  }
}






