import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/hours.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';
import 'package:intl/intl.dart';

class HoursForm extends StatefulWidget {
  HoursForm(this.business, this.halfDayIdMorning, this.halfDayIdAfternoon);

  Business business;
  int halfDayIdMorning;
  int halfDayIdAfternoon;

  HoursFormState createState() => HoursFormState();
}

class HoursFormState extends State<HoursForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String namePresta;
  String description;
  double price;

  final format = new NumberFormat("00");

  bool isLoading;

  double _lowerValueMorning = 360.0;
  double _upperValueMorning = 780.0;

  double _lowerValueAfternoon = 780.0;
  double _upperValueAfternoon = 1320.0;

  void initState() {
    super.initState();

    loadHours();
  }

  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: formKey,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 25),
                      child: new Column(
                        children: <Widget>[
                          Container(
                            padding:
                                EdgeInsets.only(left: 5, right: 5, top: 50),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Le matin : \n  de " +
                                      '${format.format(_lowerValueMorning.toInt() ~/ 60)}' +
                                      " h " +
                                      '${format.format(_lowerValueMorning.toInt() % 60)}' +
                                      " à " +
                                      '${format.format(_upperValueMorning.toInt() ~/ 60)}' +
                                      " h " +
                                      '${format.format(_upperValueMorning.toInt() % 60)}',
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 20),
                                ),
                                RangeSlider(
                                  min: 360.0,
                                  max: 780.0,
                                  lowerValue: _lowerValueMorning,
                                  upperValue: _upperValueMorning,
                                  divisions: 84,
                                  showValueIndicator: false,
                                  onChanged: (double newLowerValue,
                                      double newUpperValue) {
                                    setState(() {
                                      _lowerValueMorning = newLowerValue;
                                      _upperValueMorning = newUpperValue;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(left: 5, right: 5, top: 50),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "L'après midi : \n  de " +
                                      '${format.format(_lowerValueAfternoon.toInt() ~/ 60)}' +
                                      " h " +
                                      '${format.format(_lowerValueAfternoon.toInt() % 60)}' +
                                      " à " +
                                      '${format.format(_upperValueAfternoon.toInt() ~/ 60)}' +
                                      " h " +
                                      '${format.format(_upperValueAfternoon.toInt() % 60)}',
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 20),
                                ),
                                RangeSlider(
                                  min: 780.0,
                                  max: 1320.0,
                                  lowerValue: _lowerValueAfternoon,
                                  upperValue: _upperValueAfternoon,
                                  divisions: 108,
                                  showValueIndicator: false,
                                  onChanged: (double newLowerValue,
                                      double newUpperValue) {
                                    setState(() {
                                      _lowerValueAfternoon = newLowerValue;
                                      _upperValueAfternoon = newUpperValue;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(left: 5, right: 5, top: 50),
                            child: new SizedBox(
                              child: RaisedButton(
                                onPressed: submit,
                                child: Text(
                                  'Valider',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                ),
                                color: Color(0xFF3388FF).withOpacity(0.8),
                              ),
                              width: double.infinity,
                              height: 55,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  submit() async {
    final Hour = FirebaseDatabase.instance.reference().child('shedule');

    var business = await widget.business;
    String businessId = business.id;
    var halfDayIdMorning = await widget.halfDayIdMorning;
    var halfDayIdAfternoon = await widget.halfDayIdAfternoon;

    await Hour.once().then((DataSnapshot snapshot) {
      //Horaire dans la bdd
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null)
        values.forEach((k, v) async {
          //Si il concerne l'utilisateur connecté et la journée
          if (v["businessId"] == widget.business.id &&
              (v["halfDayId"] == halfDayIdAfternoon || v["halfDayId"] == halfDayIdMorning)) if (this.mounted) {
            print("pouleet");
            await Hour
                .child(Hours.fromMap(k, v).id)
                .remove();
          }
        });
    });

    Hour.push().set({
      'businessId': businessId,
      'closingTime': _upperValueMorning,
      'halfDayId': halfDayIdMorning,
      'openingTime': _lowerValueMorning,
    });

    Hour.push().set({
      'businessId': businessId,
      'closingTime': _upperValueAfternoon,
      'halfDayId': halfDayIdAfternoon,
      'openingTime': _lowerValueAfternoon,
    });
    Navigator.of(context).pop();
  }

  Future<void> loadHours() async {
    print(widget.business);
    var halfDayIdMorning = await widget.halfDayIdMorning;
    var halfDayIdAfternoon = await widget.halfDayIdAfternoon;
    widget.business.prestation = [];
    await FirebaseDatabase.instance
        .reference()
        .child('shedule')
        .once()
        .then((DataSnapshot snapshot) {
      //Pour chaque prestation disponnible en bdd
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null)
        values.forEach((k, v) async {
          //Si il concerne l'utilisateur connecté on l'ajoute a la liste
          if (v["businessId"] == widget.business.id && v["halfDayId"] == halfDayIdAfternoon) if (this.mounted) {
            setState(() {
              _lowerValueAfternoon = Hours.fromMap(k, v).openingTime;
              _upperValueAfternoon = Hours.fromMap(k, v).closingTime;
            });
          }

          if (v["businessId"] == widget.business.id && v["halfDayId"] == halfDayIdMorning) if (this.mounted) {
            setState(() {
              _lowerValueMorning = Hours.fromMap(k, v).openingTime;
              _upperValueMorning = Hours.fromMap(k, v).closingTime;
            });
          }
        });
    });
  }
}
