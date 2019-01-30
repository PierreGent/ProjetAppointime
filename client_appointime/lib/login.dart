import 'package:flutter/material.dart';
import 'globalVar.dart' as globalVar;
import 'package:firebase_auth/firebase_auth.dart';
import 'validation.dart';

/* ************* CONNEXION ************** */

class ConnectPage extends StatefulWidget {
  ConnectPageState createState() => ConnectPageState();
}

class ConnectPageState extends State<ConnectPage>
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
  bool autoValidate = false;
  String email;
  String pass;
  String errorMessage;

  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: -1, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.6, 1.0, curve: Curves.fastOutSlowIn)));

    muchMuchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn)));
  }

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Form(
            key: formKey,
            autovalidate: autoValidate,
            child: FormUI(),
          );
        });
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
                    "Connexion",
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
                    validator: (value) => value.isEmpty ? 'Le mot de passe ne peut pas être vide' : null,
                    onSaved: (value) => pass = value,
                  ),
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
                    child: Text("Se connecter"),
                    onPressed: submit,
                    color: globalVar.couleurSecondaire,
                    textColor: globalVar.couleurPrimaire,
                  ),
                  OutlineButton(
                    child: Text("   S'inscrire    "),
                    onPressed: () {
                      globalVar.pageController.nextPage(
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
      ],
    );
  }


  submit() async {
    final form = formKey.currentState;
    setState(() {
      errorMessage = "";
    });
    if (form.validate()) {
      form.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
        print('Signed in: ${user.uid}');
      } catch (e) {
        print('Error: $e');
        setState(() {
          errorMessage = "Nom de compte ou mot de passe incorrect";
        });
      }
    } else {
      setState(() => autoValidate = true);
    }
  }

  // RESTE À AFFICHER LES MESSAGE DERREUR QUAND UN USER NE DONNE PAS LES BONS IDENTIFIANTS
}
