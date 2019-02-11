import 'package:client_appointime/pages/root_page.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:flutter/material.dart';

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
    return new MaterialApp(
        title: 'Appointime',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth()));
  }
}
