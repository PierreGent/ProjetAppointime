import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/businessdetails/footer/PrestationsForm.dart';
import 'package:client_appointime/pages/business/prestation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrestationsShowcase extends StatefulWidget {
  PrestationsShowcase(this.business, this.edit);

  final Business business;
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

  Widget build(BuildContext context) {
    if (widget.edit)
      return new Scaffold(
        body: ListView.builder(
          itemCount: widget.business.prestation.length,
          itemBuilder: buildPrestaListTile,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text("Ajouter une prestation"),
                        backgroundColor: Color(0xFF3388FF).withOpacity(0.8),
                      ),
                      body: PrestationsForm(widget.business))),
            ).then((value) {
              setState(() {
                loadPresta();
              });
            });
          },
          tooltip: 'Toggle',
          child:
              Icon(Icons.add, size: 40, color: Colors.white.withOpacity(0.8)),
        ),
      );
    else
      return new Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: widget.business.prestation.length,
            itemBuilder: buildPrestaListTile,
          ),
        ],
      );
  }

  Future<void> loadPresta() async {
    print(widget.business);
    prestation = [];

    widget.business.prestation = [];
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
    return Container(
      child: ListTile(
        //onTap: () => _navigateToBusinessDetails(business, index),
        title: new Text(presta.namePresta),
        subtitle:
            new Text("Durée : " + presta.duration.toString() + " minutes"),
        trailing: Container(
          padding: EdgeInsets.all(10),
          child: Text("Prix : " + presta.price.toString() + " €"),
        ),
      ),
    );
  }

  submit() async {
    final prestation =
        FirebaseDatabase.instance.reference().child('prestation');

    final form = formKey.currentState;

    var buisness = widget.business;
    String buisnessId = buisness.id;
    print(buisnessId);
    setState(() {
      errorMessage = "";
    });

    if (form.validate()) {
      form.save();
      prestation.push().set({
        'buisnessId': buisnessId,
        'name': namePresta,
        'description': description,
        'duration': duration,
        'price': price.toDouble(),
      });
    } else {
      setState(() => autoValidate = true);
    }
  }
}
