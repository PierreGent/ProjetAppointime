import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/businessdetails/footer/HoursForm.dart';
import 'package:client_appointime/pages/business/hours.dart';
import 'package:client_appointime/pages/business/hours.dart';
import 'package:flutter/material.dart';

class HoursList extends StatefulWidget {
  HoursList(this.business);

  final Business business;

  HoursListState createState() => HoursListState();
}

class HoursListState extends State<HoursList> {


  void initState() {
    super.initState();


  }

  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        GestureDetector(
          child: Card(
            child: ListTile(
              title: new Text("Lundi"),
            ),
          ),
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text("Horaires du lundi"),
                          backgroundColor: Color(0xFF3388FF).withOpacity(0.8),
                        ),
                        body: HoursForm(widget.business, 1, 2),
                      ),
                ),
              ),
        ),
        GestureDetector(
          child: Card(
            child: ListTile(
              title: new Text("Mardi"),
            ),
          ),
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text("Horaires du mardi"),
                          backgroundColor: Color(0xFF3388FF).withOpacity(0.8),
                        ),
                        body: HoursForm(widget.business, 3, 4),
                      ),
                ),
              ),
        ),
        GestureDetector(
          child: Card(
            child: ListTile(
              title: new Text("Mercredi"),
            ),
          ),
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text("Horaires du mercredi"),
                          backgroundColor: Color(0xFF3388FF).withOpacity(0.8),
                        ),
                        body: HoursForm(widget.business, 5, 6),
                      ),
                ),
              ),
        ),
        GestureDetector(
          child: Card(
            child: ListTile(
              title: new Text("Jeudi"),
            ),
          ),
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text("Horaires du jeudi"),
                          backgroundColor: Color(0xFF3388FF).withOpacity(0.8),
                        ),
                        body: HoursForm(widget.business, 7, 8),
                      ),
                ),
              ),
        ),
        GestureDetector(
          child: Card(
            child: ListTile(
              title: new Text("Vendredi"),
            ),
          ),
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text("Horaires du vendredi"),
                          backgroundColor: Color(0xFF3388FF).withOpacity(0.8),
                        ),
                        body: HoursForm(widget.business, 9, 10),
                      ),
                ),
              ),
        ),
        GestureDetector(
          child: Card(
            child: ListTile(
              title: new Text("Samedi"),
            ),
          ),
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text("Horaires du samedi"),
                          backgroundColor: Color(0xFF3388FF).withOpacity(0.8),
                        ),
                        body: HoursForm(widget.business, 11, 12),
                      ),
                ),
              ),
        ),
        GestureDetector(
          child: Card(
            child: ListTile(
              title: new Text("Dimanche"),
            ),
          ),
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text("Horaires du dimanche"),
                          backgroundColor: Color(0xFF3388FF).withOpacity(0.8),
                        ),
                        body: HoursForm(widget.business, 13, 14),
                      ),
                ),
              ),
        ),
      ],
    );
  }


}
