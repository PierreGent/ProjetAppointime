import 'package:client_appointime/pages/business/business.dart';
import 'package:client_appointime/pages/business/businessdetails/footer/PrestationsForm.dart';
import 'package:client_appointime/pages/business/prestation.dart';
import 'package:client_appointime/pages/calendar/day_view.dart';
import 'package:client_appointime/pages/users/user.dart';
import 'package:client_appointime/validation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class PrestationsShowcase extends StatefulWidget {
  PrestationsShowcase(this.business, this.edit,this.user);

  final Business business;
  final bool edit;
  final User user;

  PrestationsShowcaseState createState() => PrestationsShowcaseState();
}

class PrestationsShowcaseState extends State<PrestationsShowcase> {
  List<Prestation> prestation = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  String _value = '';
  String namePresta;
  String description;
  double duration = 5;
  double price;
  bool _isLoading;

  bool myBusiness=false;

  String errorMessage;
  bool isLoading;

  final format = new NumberFormat("00");

  void initState() {
    if(widget.business.boss.id==widget.user.id)
      setState(() {
        myBusiness=true;

      });

    loadPresta();
    super.initState();
  }

  Widget build(BuildContext context) {
    if (widget.edit)
      return new Scaffold(
        body: ListView.builder(
          itemCount: widget.business.prestation.length,
          itemBuilder: buildPrestaListTile,
        ),

        floatingActionButton: FloatingActionButton(
elevation: 0.0,
          isExtended: true,
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
          if (v["businessId"] == widget.business.id) if (this.mounted) {
            setState(() {
              Prestation presta=Prestation.fromMap(k, v);
              widget.business.prestation.add(presta);
              prestation.add(presta);
            });
          }
        });
    });
  }

  Widget buildPrestaListTile(BuildContext context, int index) {
    Prestation presta = prestation[index];
    return Card(
      child: ListTile(

        onTap: ()=> _selectDate(presta),
        title: new Text(presta.namePresta),

        subtitle:
            new Text("Durée : " + presta.duration.toString() + " minutes"),
        trailing: Column(children: <Widget>[Container(
          padding: EdgeInsets.all(10),
          child: Text("Prix : " + presta.price.toString() + " €"),
        ),
        showDelete(presta),],)
      ),
    );
  }

  Future _selectDate(Prestation presta) async {
if(widget.user.id==widget.business.boss.id)
  return;
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now().subtract(Duration(days: 1)),
        lastDate: new DateTime(2021),
      locale: const Locale('fr','FR')
        
    );
    if(picked != null) setState(() {
      _value = picked.toString();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DayView(widget.business,picked,presta,widget.user,myBusiness)),
      );
    });
  }


  Widget showDelete(Prestation presta){
    if(widget.edit)
    return  IconButton(
      icon: Icon(Icons.delete_forever,color: Colors.red),
      onPressed:() async =>await FirebaseDatabase.instance
          .reference()
          .child('prestation')
          .child(presta.id)
          .remove()
          .then((_) { setState(() {
        loadPresta();
      });}),
    );
    if(presta.autoConf)
    return  Icon(Icons.check,color: Colors.green);

    return  Icon(Icons.timer,color: Colors.orange);

}
  submit() async {
    final prestation =
        FirebaseDatabase.instance.reference().child('prestation');

    final form = formKey.currentState;

    var business = widget.business;
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
      });
    } else {
      setState(() => autoValidate = true);
    }
  }
}
