import 'package:client_appointime/pages/business/business.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:client_appointime/validation.dart';
import 'package:client_appointime/pages/business/prestation.dart';

class PrestationsShowcase extends StatefulWidget {
  PrestationsShowcase(this.business, this.edit);
  Business business;
  final bool edit;

  PrestationsShowcaseState createState() => PrestationsShowcaseState();
}

class PrestationsShowcaseState extends State<PrestationsShowcase> {

  List<Prestation> prestation = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  String namePresta;
  String description;
  double duration = 5;
  double price;

  String errorMessage;
  bool isLoading;

  final format = new NumberFormat("00");

  void initState() {
    super.initState();

   loadPresta();
  }


  Widget showForm() {
    return new Form(
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
                              color: Color(0xFF3388FF).withOpacity(0.8),
                            ),
                            Text(
                              "  Durée : " +
                                  '${format.format(duration.toInt() ~/ 60)}' +
                                  " h " +
                                  '${format.format(duration.toInt() % 60)}' +
                                  " minutes",
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 20),
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
                      BlacklistingTextInputFormatter(new RegExp('[\\-|\\ |\\,]'))
                    ],
                  ),
                ),
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
    );
  }

  Widget build(BuildContext context) {
    print(widget.business.prestation);
    if (widget.edit)
      return showForm();
    else
      return new ListView.builder(
        itemCount: widget.business.prestation.length,
        itemBuilder: buildPrestaListTile,
      );
  }

  Future<void> loadPresta() async {

    print(widget.business);
    prestation = [];


    widget.business.prestation = [];
    var buisness = await widget.business;
    await FirebaseDatabase.instance
        .reference()
        .child('prestation')
        .once()
        .then((DataSnapshot snapshot) {
      //Pour chaque prestation disponnible en bdd
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null)
        values.forEach((k, v) async {
          //Si il concerne l'utilisateur connecté on l'ajoute a la liste
          if (v["buisnessId"] == widget.business.id) if (this.mounted) {

            setState(() {
              widget.business.prestation.add(Prestation.fromMap(k, v));
              prestation.add(Prestation.fromMap(k, v));
            });
          }
        });
    });
  }

  Widget buildPrestaListTile(BuildContext context, int index) {
    Prestation presta = prestation[index];
    print(presta.namePresta);
    return Stack(
      children: <Widget>[
        ListTile(
          //onTap: () => _navigateToBusinessDetails(business, index),
          title: new Text(presta.namePresta),
          subtitle: new Text("Durée : " +presta.duration.toString()),
          trailing: Container(
            padding: EdgeInsets.all(10),
            child: Text("Prix : " + presta.price.toString()),
          ),
        ),
      ],
    );
  }



  submit() async {

    final prestation =
    FirebaseDatabase.instance.reference().child('prestation');

    final form = formKey.currentState;

    var buisness = await widget.business;
    String buisnessId = buisness.id;
    print(buisnessId);
    setState(() {
      errorMessage = "";
    });

    if (form.validate()) {
      form.save();
      prestation.push().set({
        'buisnessId':buisnessId,
        'name':namePresta,
        'description':description,
        'duration':duration,
        'price': price.toDouble(),
      });
    } else {
      setState(() => autoValidate = true);
    }
  }
}
