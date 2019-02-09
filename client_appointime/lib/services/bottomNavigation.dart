import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CustomBottomNavigationBarState();
  }
  
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>{
  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text("Accueil"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.calendar_today),
            title: new Text("Mes rendez-vous"),
          )
        ]
    );
  }

}