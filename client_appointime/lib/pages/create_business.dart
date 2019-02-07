import 'package:flutter/material.dart';
import 'package:client_appointime/globalVar.dart' as globalVar;
import 'package:client_appointime/validation.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  bool _isInAsyncCall = false;
  bool _isSiretUsed = false;
  bool started=false;
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

  String validateSiret(String value) {
    if (value.length != 14) return 'Le numéro siret n\'est pas valide';

    if (_isSiretUsed) {
      // disable message until after next async call
      _isSiretUsed = false;
      return 'Siret déjâ utilisé';
    }

    return null;
  }

  Widget build(BuildContext context) {
    animationController.forward();
    return Scaffold(
      appBar: AppBar(
        title:Text("Renseigner mon entreprise"),
        backgroundColor: Colors.blueAccent.withOpacity(0.8),
      ),
      backgroundColor: globalVar.couleurPrimaire,
      body: ModalProgressHUD(
        child: AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              if(started)
                formKey.currentState?.validate();
              return Form(
                  key: this.formKey,
                  autovalidate: autoValidate,
                  child: Stack(
                    children: <Widget>[
                      FormUI(),
                      _showCircularProgress(),
                    ],
                  ));
            }),
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
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
      child: Column(
        children: <Widget>[
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
                            color: Colors.blueAccent.withOpacity(0.8)
                        ),
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
                        hintText: '\n\nDescription',
                        icon: new Icon(
                          Icons.chrome_reader_mode,
                          color: Colors.blueAccent.withOpacity(0.8),
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
                          color: Colors.blueAccent.withOpacity(0.8),
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
                        hintText:
                            'Nombre de jours pour l"annulation d\'un rendez vous',
                        icon: new Icon(
                          Icons.timer,
                          color: Colors.blueAccent.withOpacity(0.8),
                        ),
                      ),
                      validator: validateCancelAppointment,
                      onSaved: (value) =>
                          cancelAppointment = num.tryParse(value),
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
                          color: Colors.blueAccent.withOpacity(0.8),
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
                          color: Colors.blueAccent.withOpacity(0.8),
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
                      color: Colors.blueAccent.withOpacity(0.8),
                      textColor: Colors.white,
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
    started=true;
    final BusinessDetails =
        FirebaseDatabase.instance.reference().child('business');
    final form = formKey.currentState;

    String userId = "";

    var user = await widget.auth.getCurrentUser();
    userId = user.uid;
    if (form.validate() && await validateBusiness(userId) == null) {
      form.save();

      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
        errorMessage = "";
        _isLoading = true;
        _isInAsyncCall = true;
      });
      Future.delayed(Duration(seconds: 1), () async {
        _isSiretUsed = await isSiretUsed(siret);

        setState(() {
          _isInAsyncCall = false;
        });

        if (!_isSiretUsed) {
          try {
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
          _isLoading = false;

          Navigator.pop(context);
        }
      });
    } else {
      if(form.validate())
        errorMessage = "" + await validateBusiness(userId);
      setState(() => autoValidate = true);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
