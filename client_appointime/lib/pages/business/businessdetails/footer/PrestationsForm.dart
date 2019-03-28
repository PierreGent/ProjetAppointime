import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/prestation.dart';
import 'package:client_appointime/validation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PrestationsForm extends StatefulWidget {
  PrestationsForm(this.business);

  Business business;

  PrestationsFormState createState() => PrestationsFormState();
}

class PrestationsFormState extends State<PrestationsForm> {
  List<Prestation> prestation = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  String namePresta;
  String description;
  double duration = 5;
  double price;
  bool autoConf=false;

  String errorMessage;
  bool isLoading;

  final format = new NumberFormat("00");

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: formKey,
                autovalidate: autoValidate,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 20),
                      child: new Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: TextFormField(
                              autovalidate: autoValidate,
                              validator: validateName,
                              onSaved: (value) => namePresta = value,
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
                              autovalidate: autoValidate,
                              validator: validateDesc,
                              onSaved: (value) => description = value,
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
                                        color:
                                            Color(0xFF3388FF).withOpacity(0.8),
                                      ),
                                      Text(
                                        "  Durée : " +
                                            '${format.format(duration.toInt() ~/ 60)}' +
                                            " h " +
                                            '${format.format(duration.toInt() % 60)}' +
                                            " minutes",
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Slider(
                                    value: duration,
                                    max: 300,
                                    min: 5,
                                    divisions: 59,
                                    label:
                                    '${format.format(duration.toInt() ~/ 60)}' +
                                        " h " +
                                        '${format.format(duration.toInt() % 60)}' ,
                                    onChanged: (newRating) {
                                      setState(() => duration = newRating);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: TextFormField(
                              autovalidate: autoValidate,
                              validator: validatePrice,
                              onSaved: (value) => price = double.parse(value),
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
                              inputFormatters: [
                                BlacklistingTextInputFormatter(
                                    new RegExp('[\\-|\\ |\\,]'))
                              ],
                            ),
                          ),
                          Container(child: CheckboxListTile(
                            title: Text(
                              "Confirmation automatique des rendez vous",
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            value: autoConf,
                            onChanged: (bool value) {
                              setState(() {
                                autoConf = value;
                              });
                            },
                          ),),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: new SizedBox(
                              child: RaisedButton(
                                onPressed: submit,
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  submit() async {
    final prestation =
        FirebaseDatabase.instance.reference().child('prestation');

    final form = formKey.currentState;

    var business = await widget.business;
    String businessId = business.id;
    print(businessId);
    setState(() {
      errorMessage = "";
    });

    if (form.validate()) {
      form.save();
      prestation.push().set({
        'businessId': businessId,
        'name': namePresta,
        'description': description,
        'duration': duration,
        'price': price.toDouble(),
        'autoConf':autoConf,
      });
    } else {
      setState(() => autoValidate = true);
    }

    Navigator.of(context).pop();
  }
}
