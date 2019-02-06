import 'package:client_appointime/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:client_appointime/globalVar.dart' as globalVar;
import 'package:client_appointime/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';

/* ************* INSCRIPTION ************** */

class CreateBusinessPage extends StatefulWidget {
  CreateBusinessPage({this.auth});
  final BaseAuth auth;
  @override
  CreateBusinessPageState createState() => CreateBusinessPageState();
}

class CreateBusinessPageState extends State<CreateBusinessPage>
    with SingleTickerProviderStateMixin {
  // ANIMATION

  Animation animation,
      delayedAnimation,
      muchDelayedAnimation,
      muchMuchDelayedAnimation,
      muchMuchMuchDelayedAnimation,
      muchMuchMuchDelayedAnimation1,
      muchMuchMuchDelayedAnimation2,
      muchMuchMuchDelayedAnimation3,
      muchMuchMuchDelayedAnimation4;
  AnimationController animationController;

  // FORM VALIDATION

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  bool autoValidate = false;
  String name;
  String description;
  String errorMessage;
  String activity;
  int cancelAppointment;
  String siret;
  String address;
  bool _isLoading;

  void initState() {
    super.initState();
    _isLoading = false;
    errorMessage = "";
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 1, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn)));

    muchMuchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn)));

    muchMuchMuchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.4, 1.0, curve: Curves.fastOutSlowIn)));
    muchMuchMuchDelayedAnimation1 = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));
    muchMuchMuchDelayedAnimation2 = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.6, 1.0, curve: Curves.fastOutSlowIn)));
    muchMuchMuchDelayedAnimation3 = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.7, 1.0, curve: Curves.fastOutSlowIn)));
    muchMuchMuchDelayedAnimation4 = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn)));
  }

  Widget build(BuildContext context) {
    animationController.forward();
    return Scaffold(
        backgroundColor: globalVar.couleurPrimaire,
     body: AnimatedBuilder(

        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Form(
              key: formKey,
              autovalidate: autoValidate,
              child: Stack(
                children: <Widget>[
                  FormUI(),
                  _showCircularProgress(),
                ],
              ));
        }),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget FormUI() {
    final width = MediaQuery.of(context).size.width.toDouble();
    return SingleChildScrollView(
      child:Column(

      children: <Widget>[
        Transform(
          transform:
              Matrix4.translationValues(animation.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Renseigner mon entreprise",
                    style: TextStyle(
                        color: globalVar.couleurSecondaire,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ],
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
              delayedAnimation.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    autovalidate: autoValidate,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Nom de l'entreprise",
                      icon: new Icon(Icons.business,
                          color: globalVar.couleurSecondaire),
                    ),
                    validator: validateLastName,
                    onSaved: (value) => name = value,
                  ),
                ],
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
              muchDelayedAnimation.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                    autovalidate: autoValidate,
                    maxLines: 5,
                    obscureText: false,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Déscription',
                      icon: new Icon(
                        Icons.chrome_reader_mode,
                        color: globalVar.couleurSecondaire,
                      ),
                    ),
                    validator: validateDesc,
                    onSaved: (value) => description = value,
                  ),
                ],
              ),
            ),
          ),
        ),

        Transform(
          transform: Matrix4.translationValues(
              muchMuchMuchDelayedAnimation.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                    autovalidate: autoValidate,
                    maxLines: 1,
                    obscureText: false,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Domaine d\'activité',
                      icon: new Icon(
                        Icons.work,
                        color: globalVar.couleurSecondaire,
                      ),
                    ),
                    validator: validateFirstName,
                    onSaved: (value) => activity = value,
                  ),
                ],
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
              muchMuchMuchDelayedAnimation1.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                    autovalidate: autoValidate,
                    maxLines: 1,
                    obscureText: false,
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      hintText: 'Nombre de jours pour l"annulation d\'un rendez vous',
                      icon: new Icon(
                        Icons.timer,
                        color: globalVar.couleurSecondaire,
                      ),
                    ),
                    validator: validateCancelAppointment,
                    onSaved: (value) => cancelAppointment = num.tryParse(value),
                  ),
                ],
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
              muchMuchMuchDelayedAnimation.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                    autovalidate: autoValidate,
                    maxLines: 1,
                    obscureText: false,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Numéro de siret',
                      icon: new Icon(
                        Icons.no_encryption,
                        color: globalVar.couleurSecondaire,
                      ),
                    ),
                    validator: validateSiret,
                    onSaved: (value) => siret = value,
                  ),
                ],
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
              muchMuchMuchDelayedAnimation2.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                    autovalidate: autoValidate,
                    maxLines: 1,
                    obscureText: false,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Adresse',
                      icon: new Icon(
                        Icons.add_location,
                        color: globalVar.couleurSecondaire,
                      ),
                    ),
                    validator: validateAddress,
                    onSaved: (value) => address = value,
                  ),
                ],
              ),
            ),
          ),
        ),

        Transform(
          transform: Matrix4.translationValues(
              0.0, muchMuchMuchDelayedAnimation4.value * width, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text("   Valider   "),
                    onPressed: submit,
                    color: globalVar.couleurSecondaire,
                    textColor: globalVar.couleurPrimaire,
                  ),

                ],
              ),
            ),
          ),
        ),
        _showErrorMessage(),
      ],
      ),
    );
  }

  Widget _showErrorMessage() {
    if (errorMessage.length > 0 && errorMessage != null) {
      return new Text(
        errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  submit() async {
    final BusinessDetails = FirebaseDatabase.instance.reference().child('business');
    final form = formKey.currentState;
    setState(() {
      errorMessage = "";
      _isLoading = true;
    });

    String userId = "";
    bool issiretused=await isSiretUsed(siret);
    if (form.validate() &&  !issiretused) {
        form.save();
        try {
          var user = await widget.auth.getCurrentUser();
          userId = user.uid;
          BusinessDetails.push().set({
            'name': name,
            'boss': userId,
            'address': address,
            'siret': siret,
            'description': description,
            'fieldOfActivity': activity,
            'cancelAppointment': cancelAppointment
          });
        } catch (e) {
          print('Error: $e');
          setState(() {
            _isLoading = false;

            errorMessage = "erreur";
          });
        }

    } else {
      errorMessage="";
      if(form.validate())
        errorMessage="erreur inconnue";
      if(issiretused)
        errorMessage ="Siret déja utilisé";
      errorMessage=errorMessage+await validateBusiness(userId);
      setState(() => autoValidate = true);
    }
    setState(() {
      _isLoading = false;
    });
    if (userId.length > 0 && userId != null) {
      Navigator.pop(context);
    }

  }
}
