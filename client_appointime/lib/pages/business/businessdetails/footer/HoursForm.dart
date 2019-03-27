import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/hours.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';
import 'package:intl/intl.dart';

class HoursForm extends StatefulWidget {
  HoursForm(this.business, this.halfDayIdMorning, this.halfDayIdAfternoon,this.houreList);

  Business business;
  int halfDayIdMorning;
  int halfDayIdAfternoon;
  List<List<double>> houreList;

  HoursFormState createState() => HoursFormState();
}

class HoursFormState extends State<HoursForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String namePresta;
  String description;
  double price;
  List<List<double>> houreList;

  final format = new NumberFormat("00");

  bool isLoading;

  double _lowerValueMorning = 360.0;
  double _upperValueMorning = 780.0;

  double _lowerValueAfternoon = 780.0;
  double _upperValueAfternoon = 1320.0;

  void initState() {
    houreList=widget.houreList;
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
                                  valueIndicatorFormatter: (id,m){
                                    if(id==0)
                                    return("${format.format(_lowerValueMorning.toInt() ~/ 60)}"+
                                        " h " +
                                        '${format.format(_lowerValueMorning.toInt() % 60)}' );
                                    else
                                      return("${format.format(_upperValueMorning.toInt() ~/ 60)}"+
                                        " h " +
                                        "${format.format(_upperValueMorning.toInt() % 60)}");
                                  },
                                  showValueIndicator: true,
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
                                  valueIndicatorFormatter: (id,m){
                                    if(id==0)
                                      return("${format.format(_lowerValueAfternoon.toInt() ~/ 60)}"+
                                          " h " +
                                          '${format.format(_lowerValueAfternoon.toInt() % 60)}' );
                                    else
                                      return("${format.format(_upperValueAfternoon.toInt() ~/ 60)}"+
                                          " h " +
                                          "${format.format(_upperValueAfternoon.toInt() % 60)}");
                                  },
                                  showValueIndicator: true,
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

 loadHours()  {
  var halfDayIdAfternoon =  widget.halfDayIdAfternoon;
    setState(() {
      if(houreList[(halfDayIdAfternoon~/2)-1].length>2)
      _lowerValueAfternoon = houreList[(halfDayIdAfternoon~/2)-1][2];
      if(houreList[(halfDayIdAfternoon~/2)-1].length>3)
      _upperValueAfternoon = houreList[(halfDayIdAfternoon~/2)-1][3];

      if(houreList[(halfDayIdAfternoon~/2)-1].length>0)
      _lowerValueMorning = houreList[(halfDayIdAfternoon~/2)-1][0];

      if(houreList[(halfDayIdAfternoon~/2)-1].length>1)
      _upperValueMorning = houreList[(halfDayIdAfternoon~/2)-1][1];
    });
  }
}
