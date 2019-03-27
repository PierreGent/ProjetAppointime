import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/businessdetails/footer/HoursForm.dart';
import 'package:client_appointime/pages/business/hours.dart';
import 'package:client_appointime/pages/business/hours.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HoursList extends StatefulWidget {
  HoursList(this.business);

  final Business business;

  HoursListState createState() => HoursListState();
}

class HoursListState extends State<HoursList> {
List<List<double>> houreList=[];
final format = new NumberFormat("00");
bool isLoading;
  void initState() {
    loadHours();
    super.initState();


  }
  Future<void> loadHours()  async {
    setState(() {
      isLoading=true;
    });
    houreList=[];
    print(widget.business);

    for(int i=1;i<14;i+=2) {
      await FirebaseDatabase.instance
          .reference()
          .child('shedule')
      .orderByChild("businessId")
      .equalTo(widget.business.id)
          .once()
          .then((DataSnapshot snapshot) {
        List<double> listHoures=[];
        //Pour chaque prestation disponnible en bdd
        Map<dynamic, dynamic> values = snapshot.value;
        widget.business.businessShedule=values;
        if (values != null)
          values.forEach((k, v) {
            //Si il concerne l'utilisateur connecté on l'ajoute a la liste
            if (
                v["halfDayId"] == i+1) {
              listHoures.add(Hours
                  .fromMap(k, v)
                  .openingTime);
              listHoures.add(Hours
                  .fromMap(k, v)
                  .closingTime);
            }

            if (v["businessId"] == widget.business.id &&
                v["halfDayId"] == i) {
              listHoures.add(Hours
                  .fromMap(k, v)
                  .openingTime);
              listHoures.add(Hours
                  .fromMap(k, v)
                  .closingTime);
            }

          });
        if(this.mounted)
        setState(() {
          listHoures.sort((a,b)=>a.compareTo(b));
          houreList.add(listHoures);
        });
      });

    }
    if(this.mounted)
    print(houreList.toString());
    setState(() {
      isLoading=false;
    });
  }
String getStringHoures(int i){
    if(houreList.elementAt(i).length<1)
      return "Aucun horaire spécifié";
  return '${format.format(houreList.elementAt(i).elementAt(0)~/60)}'+"h"+'${format.format(houreList.elementAt(i).elementAt(0)%60)}'+"->"+
      '${format.format(houreList.elementAt(i).elementAt(1)~/60)}'+"h"+'${format.format(houreList.elementAt(i).elementAt(1)%60)}'+"\n"+
      '${format.format(houreList.elementAt(i).elementAt(2)~/60)}'+"h"+'${format.format(houreList.elementAt(i).elementAt(2)%60)}'+"->"+
  '${format.format(houreList.elementAt(i).elementAt(3)~/60)}'+"h"+'${format.format(houreList.elementAt(i).elementAt(3)%60)}';

}
  Widget build(BuildContext context) {
    if(isLoading)
      return new Center(
        child: CircularProgressIndicator(),
      );
    return ListView(
      children: <Widget>[
        GestureDetector(
          child: Card(
            child: ListTile(
              title: new Text("Lundi"),
              trailing: new Text(getStringHoures(0)),
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
                        body: HoursForm(widget.business, 1, 2,houreList),
                      ),
                ),
              ).then((test){
            loadHours();
          }),
        ),
        GestureDetector(
          child: Card(
            child: ListTile(
              title: new Text("Mardi"),
              trailing: new Text(getStringHoures(1)),
            ),
          ),
          onTap: () {
            Navigator.push(

              context,
              MaterialPageRoute(
                builder: (context) =>
                    Scaffold(
                      appBar: AppBar(
                        title: Text("Horaires du mardi"),
                        backgroundColor: Color(0xFF3388FF).withOpacity(0.8),
                      ),
                      body: HoursForm(widget.business, 3, 4, houreList),
                    ),
              ),
            ).then((test) {
              loadHours();
            })
            ;
          }
        ),
        GestureDetector(
          child: Card(
            child: ListTile(
              title: new Text("Mercredi"),
              trailing: new Text(getStringHoures(2)),
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
                        body: HoursForm(widget.business, 5, 6,houreList),
                      ),
                ),
              ).then((test){
            loadHours();
          }),
        ),
        GestureDetector(
          child: Card(
            child: ListTile(
              title: new Text("Jeudi"),
              trailing: new Text(getStringHoures(3)),
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
                        body: HoursForm(widget.business, 7, 8,houreList),
                      ),
                ),
              ).then((test){
                loadHours();
          }),
        ),
        GestureDetector(
          child: Card(
            child: ListTile(
              title: new Text("Vendredi"),
              trailing: new Text(getStringHoures(4)),
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
                        body: HoursForm(widget.business, 9, 10,houreList),
                      ),
                ),
              ).then((test){
            loadHours();
          }),
        ),
        GestureDetector(
          child: Card(
            child: ListTile(
              title: new Text("Samedi"),
              trailing: new Text(getStringHoures(5)),
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
                        body: HoursForm(widget.business, 11, 12,houreList),
                      ),
                ),
              ).then((test){
            loadHours();
          }),
        ),
        GestureDetector(
          child: Card(
            child: ListTile(
              title: new Text("Dimanche"),
              trailing: new Text(getStringHoures(6)),
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
                        body: HoursForm(widget.business, 13, 14,houreList),
                      ),
                ),
              ).then((test){
            loadHours();
          }),
        ),
      ],
    );
  }


}
