import 'package:client_appointime/pages/business/business.dart';
import 'package:flutter/material.dart';

class PrestationsShowcase extends StatefulWidget {
  PrestationsShowcase(this.business);
  Business business;

  PrestationsShowcaseState createState() => PrestationsShowcaseState();
}

class PrestationsShowcaseState extends State<PrestationsShowcase> {
  double sliderValue = 5;
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 25, right: 25, top: 20),
          child: new Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20),
                child: TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.mail,
                        color: Color(0xFF3388FF).withOpacity(0.8)),
                    labelText: 'Nom de la prestation',
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: TextFormField(
                  maxLines: 5,
                  obscureText: false,
                  autofocus: false,
                  decoration: new InputDecoration(
                    labelText: 'Description',
                    prefixIcon: new Icon(
                      Icons.chrome_reader_mode,
                      color: Color(0xFF3388FF).withOpacity(0.8),
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.timer,
                            color: Color(0xFF3388FF).withOpacity(0.8),
                          ),
                          Text(
                            "  Durée : " +
                                '${sliderValue.toInt() ~/ 60}' +
                                " h " +
                                '${sliderValue.toInt() % 60}' +
                                " minutes",
                            style:
                                TextStyle(color: Colors.black45, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Slider(
                        value: sliderValue,
                        max: 300,
                        min: 5,
                        divisions: 59,
                        onChanged: (newRating) {
                          setState(() => sliderValue = newRating);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: TextFormField(
                  maxLines: 1,
                  obscureText: false,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    prefixIcon: new Icon(
                      Icons.euro_symbol,
                      color: Color(0xFF3388FF).withOpacity(0.8),
                    ),
                    labelText: 'Prix',
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: new SizedBox(
                  child: RaisedButton(

                    child: Text(
                      'Ajouter',
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
    );
  }
}
