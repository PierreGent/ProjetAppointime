import 'package:flutter/material.dart';
import 'package:client_appointime/globalVar.dart' as globalVar;
import 'package:client_appointime/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:client_appointime/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';

/* ************* INSCRIPTION ************** */

class InscPage extends StatefulWidget {
  InscPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  InscPageState createState() => InscPageState();
}

class InscPageState extends State<InscPage>
    with SingleTickerProviderStateMixin {
  // ANIMATION

  Animation animation,
      delayedAnimation,
      muchDelayedAnimation,
      muchMuchDelayedAnimation,
      muchMuchMuchDelayedAnimation;
  AnimationController animationController;

  // FORM VALIDATION

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  bool autoValidate = false;
  bool isPro = false;
  String email;
  String pass;
  String passConf;
  String errorMessage;
  String firstName;
  String lastName;
  String phone;
  String address;
  bool _isLoading;

  void initState() {
    super.initState();
    _isLoading = false;
    errorMessage="";
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 1, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.6, 1.0, curve: Curves.fastOutSlowIn)));

    muchMuchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn)));
  }

  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
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
            )

          );
        });
  }
  Widget _showCircularProgress(){
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } return Container(height: 0.0, width: 0.0,);

  }
  Widget FormUI() {
    final width = MediaQuery.of(context).size.width.toDouble();
    return ListView(
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
                    "Inscription",
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
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      icon: new Icon(Icons.mail,
                          color: globalVar.couleurSecondaire),
                    ),
                    validator: validateEmail,
                    onSaved: (value) => email = value,
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
                    key: passKey,
                    autovalidate: autoValidate,
                    maxLines: 1,
                    obscureText: true,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Mot de passe',
                      icon: new Icon(
                        Icons.lock,
                        color: globalVar.couleurSecondaire,
                      ),
                    ),
                    validator: validatePass,
                    onSaved: (value) => pass = value,
                  ),
                ],
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
              muchMuchDelayedAnimation.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                    autovalidate: autoValidate,
                    maxLines: 1,
                    obscureText: true,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Confirmation',
                      icon: new Icon(
                        Icons.beenhere,
                        color: globalVar.couleurSecondaire,
                      ),
                    ),
                    validator: (confirm) {
                      print("ddskffskj");
                      return validatePassConfirm(
                          confirm, passKey.currentState.value);
                    },
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
                    maxLines: 1,
                    obscureText: false,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Prénom',
                      icon: new Icon(
                        Icons.supervised_user_circle,
                        color: globalVar.couleurSecondaire,
                      ),
                    ),
                    validator: validateFirstName,
                    onSaved: (value) => firstName = value,
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
                    maxLines: 1,
                    obscureText: false,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Nom',
                      icon: new Icon(
                        Icons.supervised_user_circle,
                        color: globalVar.couleurSecondaire,
                      ),
                    ),
                    validator: validateLastName,
                    onSaved: (value) => lastName = value,
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
              muchDelayedAnimation.value * width, 0.0, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                    autovalidate: autoValidate,
                    keyboardType: TextInputType.phone,
                    maxLines: 1,
                    obscureText: false,
                    autofocus: false,
                    decoration: new InputDecoration(
                      hintText: 'Numéro de téléphone',
                      icon: new Icon(
                        Icons.phone,
                        color: globalVar.couleurSecondaire,
                      ),
                    ),
                    validator: validatePhone,
                    onSaved: (value) => phone = value,
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
                  new CheckboxListTile(
                    title: Text("Cochez si vous etes professionnel"),
                    value: isPro,
                    onChanged: (bool value) {
                      setState(() {
                        isPro = value;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
              0.0, muchMuchDelayedAnimation.value * width, 0.0),
          child: new Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text("   S'inscrire    "),
                    onPressed: submit,
                    color: globalVar.couleurSecondaire,
                    textColor: globalVar.couleurPrimaire,
                  ),
                  OutlineButton(
                    child: Text("Se connecter"),
                    onPressed: () {
                      globalVar.pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                    color: globalVar.couleurSecondaire,
                    textColor: globalVar.couleurSecondaire,
                    highlightColor: globalVar.couleurSecondaire,
                    borderSide: BorderSide(
                      color: globalVar.couleurSecondaire,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        _showErrorMessage(),
      ],
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
    final userDetails = FirebaseDatabase.instance.reference().child('users');
    final form = formKey.currentState;
    setState(() {
      errorMessage = "";
      _isLoading = true;
    });

    String userId = "";
    if (form.validate()) {
      form.save();
      try {
        userId = await widget.auth.signUp( email, pass);
        widget.auth.signUpFull(userId, firstName, lastName, address, phone, isPro);

        print('Signed in: ${userId}');
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;

          errorMessage = "Nom de compte ou mot de passe incorrect";
        });
      }
    } else {
      setState(() => autoValidate = true);
    }
    if (userId.length > 0 && userId != null) {
      widget.onSignedIn();
    }
    setState(() {
      _isLoading = false;
    });

  }
}
